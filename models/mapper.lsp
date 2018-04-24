(when (not (file? "pom.xml"))
  (throw-error "Not in project directory."))

(print "Input db prefix: ")
(set 'pre (read-line))

(define Entity:Entity)
(define Type:Type)
(Entity "BusinessObject" (list "com.gionee.gnif.core.model.impl" (list "BusinessObject") nil))

(Type "String" "varchar(128)")
(Type "Integer" "integer")
(Type "Character" "char(2)")
(Type "Date" "datetime")
(Type "char" "char(1)")
(Type "BigDecimal" "integer")
(Type "float" "float")
(Type "int" "integer")

(define (handle-model file-name)
  (when (file? file-name)
    (letn (package class field)
      (set 'entity (open file-name "read"))
      (while (read-line entity)
        (set 'line (regex ".*(package.*;|private.*;|public.*class)" (current-line)))
        (when line
          (letn
              ((p (regex "[ \t]*package[ \t](.*);" (current-line)))
               (c (if (not p) (regex ".*class[ \t]+([^ ]+)" (current-line)) nil))
               (f (if (not c) (regex "[ \t]*private[ \t]([^ ]+)[ \t]([^ ]+);" (current-line)) nil)))
            (when p
              (setq package $1))
            (when c
              (setq class (filter (lambda (x) (> (length x) 0)) (parse (current-line) "(public|class|extends|implements|[; \t{])+" 0))))
            (when (and f (not (find "NoDB" (current-line))))
              (set 'column $2)
			  (if (Type $1)
				  (push (list $1 $2 (Type $1) (string (replace "([A-Z])" column (string "_" (lower-case $1)) 0) "_")) field)
				  (println "Type " $1 " can not be resolved."))))))
      (close entity)
      (when (and package class field)
        (Entity (first class) (list package class (reverse field)))))))

(define (handle-struct name)
  (when (and (Entity name) (list? ((Entity name) 1)))
    (push name hierarchy)
    (dolist (m (rest ((Entity name) 1)))
      (handle-struct m))))

(define (generate-mapper)
  (write-file (append "target/mapper/" name ".xml") (string "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<!DOCTYPE mapper PUBLIC \"-//mybatis.org//DTD Mapper 3.0//EN\" \"http://mybatis.org/dtd/mybatis-3-mapper.dtd\">
<mapper namespace=\"" package "." name "Entity\">

  <sql id=\"column" name "\">
" (let ((ret ""))
        (dolist (f field)
          (extend ret "    " (f 3) ",
"))
        (replace "[, \r\n]+$" ret "" 0)) "
  </sql>

  <insert id=\"insert" name "\" parameterType=\"" package "." name "Entity\">
    insert into " tname " (<include refid=\"column" name "\"/>)
    values (
" (let ((ret ""))
                (dolist (f field)
                  (extend ret "      #{" (f 1) "},
"))
                (replace "[, \r\n]+$" ret "" 0)) ")
  </insert>

  <update id=\"update" name "\" parameterType=\"" package "." name "Entity\">
    update " tname "
       set
"
    (let ((ret ""))
      (dolist (f field)
        (extend ret "         " (f 3) " = #{" (f 1) "},
"))
      (replace "[ \t]+id_.*[\r\n]+" ret "" 0)
      (replace "[ \t]+create_by_.*[\r\n]+" ret "" 0)
      (replace "[ \t]+create_time_.*[\r\n]+" ret "" 0)
      (replace "[,\r\n]+$" ret "" 0)
      (extend ret "
      where id_ = #{id}"))
"
  </update>

  <delete id=\"delete" name "\" parameterType=\"" package "." name "Entity\">
    delete from " tname " where id_ = #{id}
  </delete>
  
  <select id=\"select" name "\" parameterType=\"int\" resultMap=\"result" name "\">
    select <include refid=\"column" name "\"/> from " tname " where id_ = #{id}
  </select>

  <resultMap type=\"" package "." name "Entity\" id=\"result" name "\">
    <id property=\"id\" column=\"id_\"/>
" (let ((ret ""))
    (dolist (f field)
	  (extend ret "    <result property=\"" (f 1) "\" column=\"" (f 3) "\"/>
"))
	(replace {.*result property="id".*[\r\n]+} ret "" 0)) "  </resultMap>

</mapper>
")))

(define (generate-create-sql)
  (append-file "target/create/create.sql"
			   (string "create table " tname " (
" (let ((ret ""))
	(dolist (f field)
	  (extend ret "  " (f 3) " " (f 2) ",
"))
	ret) "  primary key (id_)
);

")))

(! "dir /b /s *Entity.java > temp")
(set 'temp (open "temp" "read"))

(while (read-line temp)
  (handle-model (current-line)))

(make-dir "target/mapper")
(make-dir "target/create")
(write-file "target/create/create.sql" "")

(dolist (i (Entity))
  (let ((hierarchy nil)
        (b nil)
        (package nil)
        (class nil)
        (field (list)))
    (handle-struct (i 0))
    (when (= (first hierarchy) "BusinessObject")
      (set 'b true)
      (extend field (list (list "Integer" "id" "integer" "id_")))
      (pop hierarchy))
    (when hierarchy
      (dolist (m hierarchy)
        (extend field ((Entity m) 2)))
      (set 'class (hierarchy -1))
      (set 'name (slice class 0 -6))
      (set 'tname (string pre name))
      (replace "([A-Z])" tname (string "_" (lower-case $1)) 0)
      (set 'package ((Entity class) 0))
    (when b
      (extend field (list (list "Integer" "status" "integer" "status_")))
      (extend field (list (list "String" "remark" "varchar(1024)" "remark_")))
      (extend field (list (list "Integer" "createBy" "integer" "create_by_")))
      (extend field (list (list "Date" "createTime" "datetime" "create_time_")))
      (extend field (list (list "Integer" "updateBy" "integer" "update_by_")))
      (extend field (list (list "Date" "updateTime" "datetime" "update_time_"))))
	(print "Handle " name "...")
    (generate-mapper)
	(generate-create-sql)
	(println " OK!"))))
  
(close temp)
(delete-file "temp")

(exit)
