---
CREATE TABLE "info" (
  "key" TEXT NOT NULL,
  "value" TEXT DEFAULT "" NOT NULL
);
CREATE UNIQUE INDEX info_key ON info(key);
INSERT INTO info (key, value) VALUES ("schema_version", "2.0");

---
CREATE TABLE "focus_areas" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "name" TEXT NOT NULL,
  "created_at" TEXT NOT NULL,
  "updated_at" TEXT NOT NULL
);

CREATE TABLE "courses" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "name" TEXT NOT NULL,
  "long_name" TEXT,
  "PO" TEXT,
  "created_at" TEXT NOT NULL,
  "updated_at" TEXT NOT NULL
);
CREATE UNIQUE INDEX course_name ON courses(name);

CREATE TABLE "departments" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "name" TEXT NOT NULL,
  "long_name" TEXT NOT NULL,
  "created_at" TEXT NOT NULL,
  "updated_at" TEXT NOT NULL
);
CREATE UNIQUE INDEX department_name ON departments(name);

CREATE TABLE "modules" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "name" TEXT NOT NULL,
  "frequency" TEXT,
  "created_at" TEXT NOT NULL,
  "updated_at" TEXT NOT NULL
);
CREATE UNIQUE INDEX module_name ON modules(name);


---
CREATE TABLE "sessions" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "group_id" INTEGER NOT NULL,
  "slot" TEXT NOT NULL,
  "rhythm" INTEGER DEFAULT 0 NOT NULL,
  "duration" INTEGER DEFAULT 2 NOT NULL,
  "created_at" TEXT NOT NULL,
  "updated_at" TEXT NOT NULL,
  FOREIGN KEY(group_id) REFERENCES groups(id)
);

CREATE TABLE "units" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "title" text not null,
  "department_id" INTEGER not null,
  "duration" INTEGER DEFAULT 0 not null,
  "created_at" text not null,
  "updated_at" text not null,
  FOREIGN KEY(department_id) REFERENCES departments(id)
);

CREATE TABLE "groups" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "unit_id" INTEGER NOT NULL,
  "title" TEXT NOT NULL,
  "created_at" TEXT NOT NULL,
  "updated_at" TEXT NOT NULL,
  FOREIGN KEY(unit_id) REFERENCES units(id)
);


---

CREATE TABLE "modules_focus_areas" (
  "module_id" INTEGER NOT NULL,
  "focus_area_id" INTEGER NOT NULL,
  FOREIGN KEY(module_id) REFERENCES modules(id),
  FOREIGN KEY(focus_area_id) REFERENCES focus_areas(id)
);

CREATE TABLE "courses_modules" (
  "course_id" INTEGER NOT NULL,
  "module_id" INTEGER NOT NULL,
  "type" TEXT NOT NULL, --- e (elective) or m (mandatory)
  FOREIGN KEY(course_id) REFERENCES courses(id),
  FOREIGN KEY(module_id) REFERENCES modules(id)
);

CREATE TABLE "courses_number_of_elective_modules" (
  "course_id" INTEGER NOT NULL,
  "amount" INTEGER NOT NULL DEFAULT "3",
  FOREIGN KEY(course_id) REFERENCES courses(id)
);

CREATE TABLE "courses_modules_number_of_elective_units" (
  "course_id" INTEGER NOT NULL,
  "module_id" INTEGER NOT NULL,
  "amount" INTEGER NOT NULL DEFAULT "3",
  FOREIGN KEY(course_id) REFERENCES courses(id),
  FOREIGN KEY(module_id) REFERENCES modules(id)
);

CREATE TABLE "courses_modules_units" (
  "course_id" INTEGER NOT NULL,
  "module_id" INTEGER NOT NULL,
  "unit_id" INTEGER NOT NULL,
  "type" TEXT NOT NULL, --- e (elective) or m (mandatory)
  FOREIGN KEY(course_id) REFERENCES courses(id),
  FOREIGN KEY(module_id) REFERENCES modules(id),
  FOREIGN KEY(unit_id) REFERENCES units(id)
);
