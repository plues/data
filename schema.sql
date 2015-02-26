CREATE TABLE "sessions" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "slot" TEXT NOT NULL,
  "rhythm" INTEGER DEFAULT 0 NOT NULL,
  "duration" INTEGER DEFAULT 2 NOT NULL,
  "created_at" TEXT NOT NULL,
  "updated_at" TEXT NOT NULL
);

CREATE TABLE "units" (
  "id" integer primary key autoincrement,
  "title" text not null,
  "department" integer not null,
  "duration" INTEGER DEFAULT 0 not null,
  "created_at" text not null,
  "updated_at" text not null,
  FOREIGN KEY(department) REFERENCES departments(name)
);

CREATE TABLE "groups" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "unit_id" INTEGER NOT NULL,
  "title" TEXT NOT NULL,
  "created_at" TEXT NOT NULL,
  "updated_at" TEXT NOT NULL,
  FOREIGN KEY(unit_id) REFERENCES units(id)
);

CREATE TABLE "group_sessions" (
  "group_id" INTEGER NOT NULL,
  "session_id" INTEGER NOT NULL,
  FOREIGN KEY(group_id) REFERENCES groups(id),
  FOREIGN KEY(session_id) REFERENCES sessions(id)
);

CREATE TABLE "mapping" (
  "module" TEXT NOT NULL,
  "class" INTEGER DEFAULT 1 NOT NULL,
  "course" TEXT NOT NULL,
  "type" TEXT DEFAULT "P" NOT NULL,
  "focus_area_id" INTEGER DEFAULT 0 NOT NULL,
  "semester" INTEGER NOT NULL,
  "unit_id" INTEGER NOT NULL,
  FOREIGN KEY(module) REFERENCES modules(name),
  FOREIGN KEY(course) REFERENCES courses(name),
  FOREIGN KEY(unit_id) REFERENCES units(id),
  FOREIGN KEY(focus_area_id) REFERENCES focus_areas(id)
);

CREATE TABLE "modules" (
  "name" TEXT PRIMARY KEY NOT NULL,
  "frequency" TEXT,
  "created_at" TEXT NOT NULL,
  "updated_at" TEXT NOT NULL
);
CREATE UNIQUE INDEX module_name ON modules(name);

CREATE TABLE "focus_areas" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "name" TEXT NOT NULL,
  "created_at" TEXT NOT NULL,
  "updated_at" TEXT NOT NULL
);

CREATE TABLE "courses" (
  "name" TEXT NOT NULL PRIMARY KEY,
  "long_name" TEXT,
  "created_at" TEXT NOT NULL,
  "updated_at" TEXT NOT NULL
);
CREATE UNIQUE INDEX course_name ON courses(name);

CREATE TABLE "departments" (
  "name" TEXT NOT NULL PRIMARY KEY,
  "long_name" TEXT NOT NULL,
  "created_at" TEXT NOT NULL,
  "updated_at" TEXT NOT NULL
);
CREATE UNIQUE INDEX department_name ON departments(name);


CREATE TABLE "info" (
  "key" TEXT NOT NULL,
  "value" TEXT DEFAULT "" NOT NULL
);
CREATE UNIQUE INDEX info_key ON info(key);
INSERT INTO info (key, value) VALUES ("schema_version", "1.1");

CREATE TABLE major_module_requirements (
  course TEXT NOT NULL,
  requirement INTEGER NOT NULL,
  FOREIGN KEY(course) REFERENCES courses(name)
);
