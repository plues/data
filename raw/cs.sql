.read "schema.sql"

INSERT INTO "info" values("generated", "2015-11-03 17:00");
INSERT INTO "info" values("Author", "Philip Höfges");
INSERT INTO "info" values("generator", "info");

INSERT INTO "departments"(name, long_name, created_at, updated_at) VALUES ("info", "Informatik", datetime('now'), datetime('now'));

INSERT INTO "courses" (name, long_name, elective_modules,  created_at, updated_at) VALUES
        ("info_bachelor",               "Informatik Bachelor", 2, datetime('now'),  datetime('now')),
        ("info_master",                 "Informatik Master", 2, datetime('now'),  datetime('now'));

INSERT INTO "focus_areas" (id, name, created_at, updated_at) VALUES
         (1,    "Softwaretechnik und Programmiersprachen", datetime('now'), datetime('now')),
         (2,    "Datenbanken und Infomationssysteme", datetime('now'), datetime('now')),
         (3,    "Rechnernetze", datetime('now'), datetime('now')),
         (4,    "Bioinformatik", datetime('now'), datetime('now')),
         (5,    "Komplexität und Kryptologie", datetime('now'), datetime('now')),
         (6,    "Geoinformatik", datetime('now'), datetime('now')),
         (7,    "Computer Vision, Computer Graphics and Pattern Recognition", datetime('now'), datetime('now')),
         (8,    "Bild- und Signalverarbeitung", datetime('now'), datetime('now')),
         (9,    "Betriebssysteme", datetime('now'), datetime('now')),
        (10,    "Algorithmen und Datenstrukturen", datetime('now'), datetime('now')),
        (11,    "Algorithmen für schwere Probleme", datetime('now'), datetime('now')),
        (12,    "Computational Social Choice", datetime('now'), datetime('now')),
        (13,    "Technik sozialer Netzwerke", datetime('now'), datetime('now'));

INSERT INTO "modules" (id, name, frequency, created_at, updated_at) VALUES
        (1,  "Info1", "WS", datetime("now"), datetime("now")),
        (2,  "LA1", "jedes Semester", datetime("now"), datetime("now")),
        (3,  "Ana1", "jedes Semester", datetime("now"), datetime("now")),
        (4,  "Info2", "SS", datetime("now"), datetime("now")),
        (5,  "ProPra", "WS", datetime("now"), datetime("now")),
        (6,  "Ana2", "jedes Semester", datetime("now"), datetime("now")),
        (7,  "Info3", "WS", datetime("now"), datetime("now")),
        (8,  "Ana3", "jedes Semester", datetime("now"), datetime("now")),
        (9,  "Stocha", "WS", datetime("now"), datetime("now")),
        (10, "Info4", "SS", datetime("now"), datetime("now")),
        (11, "Num", "SS", datetime("now"), datetime("now")),
        (12, "LA2", "jedes Semester", datetime("now"), datetime("now")),
        (13, "DBS", "WS", datetime("now"), datetime("now")),
        (14, "RN", "WS", datetime("now"), datetime("now")),
        (15, "CompMathe", "WS", datetime("now"), datetime("now"));

INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (1, 1, "a2", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (2, 1, "a5", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (3, 2, "a1", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (4, 3, "c1", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (5, 4, "b2", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (6, 4, "e4", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (7, 5, "b3", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (8, 6, "d5", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (9, 7, "b1", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (10, 7, "f3", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (11, 8, "a3", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (12, 9, "d1", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (13, 10, "a3", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (14, 10, "a5", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (15, 11, "a1", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (16, 12, "c4", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (17, 13, "c1", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (18, 14, "b2", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (19, 14, "b5", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (20, 15, "b3", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (21, 16, "d5", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (22, 17, "a2", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (23, 17, "a5", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (24, 18, "d3", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (25, 19, "b1", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (26, 19, "c3", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (27, 20, "a3", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (28, 21, "b2", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (29, 21, "b5", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (30, 22, "b3", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (31, 23, "d5", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (32, 24, "a2", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (33, 24, "c5", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (34, 25, "e2", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (35, 26, "b5", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (36, 26, "b4", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (37, 27, "c1", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (38, 28, "b2", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (39, 29, "b1", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (40, 29, "a4", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (41, 30, "c2", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (42, 31, "d1", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (43, 32, "a1", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (44, 32, "c5", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (45, 33, "c2", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (46, 34, "d3", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (47, 34, "c4", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (48, 35, "d4", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (49, 36, "b4", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (50, 37, "d1", 0, 2, datetime("now"), datetime("now"));
INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        (51, 38, "c1", 0, 2, datetime("now"), datetime("now"));

INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (1, "Grundlagen der Softwareentwicklung und Programmierung (Informatik I)", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (2, "Übungen zum Modul: Grundlagen der Softwareentwicklung und Programmierung (Informatik I)", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (3, "Praktische Übungen zum Modul: Grundlagen der Softwareentwicklung und Programmierung (Informatik I)", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (4, "Analysis I", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (5, "Analysis I - Übungen", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (6, "Analysis I - Tutorium", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (7, "Lineare Algebra I", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (8, "Lineare Algebra I - Übungen", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (9, "Lineare Algebra I - Tutorium", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (10, "Grundlagen der Technischen Informatik (Informatik II)", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (11, "Übungen zum Modul: Grundlagen der Technischen Informatik (Informatik II)", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (12, "Programmierpraktikum", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (13, "Übungen: Programmierpraktikum", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (14, "Analysis II", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (15, "Analysis II - Übungen", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (16, "Analysis II - Tutorium", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (17, "Grundlagen der Algorithmen und Datenstrukturen (Informatik III)", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (18, "Übungen zum Modul: Grundlagen der Algorithmen und Datenstrukturen (Informatik III)", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (19, "Einführung in die Stochastik", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (20, "Übungen zu Einführung in die Stochastik", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (21, "Analysis III", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (22, "Analysis III - Übungen", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (23, "Analysis III - Tutorium", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (24, "Grundlagen der Theoretischen Informatik (Informatik IV)", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (25, "Übungen zum Modul: Grundlagen der Theoretischen Informatik (Informatik IV)", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (26, "Numerik I", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (27, "Übungen zu Numerik I", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (28, "Programmierübungen zu Numerik I", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (29, "Lineare Algebra II", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (30, "Lineare Algebra II - Übungen", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (31, "Lineare Algebra II - Tutorium", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (32, "Datenbanksysteme (für BA Informatik)", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (33, "Übung zu Datenbanksysteme (für BA Informatik)", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (34, "Rechnernetze", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (35, "Rechnernetze - Hörsaalübung", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (36, "Computergestütze Mathematik", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (37, "Computergestütze Lineare Algebra - Übungen", 1, 1, datetime("now"), datetime("now"));
INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        (38, "Computergestütze Analysis - Übungen", 1, 1, datetime("now"), datetime("now"));

INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (1, 1, "Grundlagen der Softwareentwicklung und Programmierung (Informatik I)", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (2, 2, "Übungen zum Modul: Grundlagen der Softwareentwicklung und Programmierung (Informatik I)",  datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (3, 3, "Praktische Übungen zum Modul: Grundlagen der Softwareentwicklung und Programmierung (Informatik I)", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (4, 4, "Analysis I", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (5, 5, "Analysis I - Übungen", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (6, 6, "Analysis I - Tutorium", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (7, 7, "Lineare Algebra I", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (8, 8, "Lineare Algebra I - Übungen", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (9, 9, "Lineare Algebra I - Tutorium", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (10, 10, "Grundlagen der Technischen Informatik (Informatik II)", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (11, 11, "Grundlagen der Technischen Informatik (Informatik II)", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (12, 12, "Programmierpraktikum", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (13, 13, "Übungen: Programmierpraktikum", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (14, 14, "Analysis II", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (15, 15, "Analysis II - Übungen", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (16, 16, "Analysis II - Tutorium", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (17, 17, "Grundlagen der Algorithmen und Datenstrukturen (Informatik III)", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (18, 18, "Übungen zum Modul: Grundlagen der Algorithmen und Datenstrukturen (Informatik III)", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (19, 19, "Einführung in die Stochastik", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (20, 20, "Übungen zu Einführung in die Stochastik", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (21, 21, "Analysis III", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (22, 22, "Analysis III - Übungen", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (23, 23, "Analysis III - Tutorium", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (24, 24, "Grundlagen der Theoretischen Informatik (Informatik IV)", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (25, 25, "Übungen zum Modul: Grundlagen der Theoretischen Informatik (Informatik IV)", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (26, 26, "Numerik I", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (27, 27, "Übungen zu Numerik I", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (28, 28, "Programmierübungen zu Numerik I", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (29, 29, "Lineare Algebra II", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (30, 30, "Lineare Algebra II - Übungen", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (31, 31, "Lineare Algebra II - Tutorium", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (32, 32, "Datenbanksysteme (für BA Informatik)", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (33, 33, "Übung zu Datenbanksysteme (für BA Informatik)", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (34, 34, "Rechnernetze", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (35, 35, "Rechnernetze - Hörsaalübung", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (36, 36, "Computergestütze Mathematik", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (37, 37, "Computergestütze Lineare Algebra - Übungen", datetime("now"), datetime("now"));
INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        (38, 38, "Computergestütze Analysis - Übungen", datetime("now"), datetime("now"));

INSERT INTO "courses_modules" (course_id, module_id, type) VALUES
        (1, 1, "m");
INSERT INTO "courses_modules" (course_id, module_id, type) VALUES
        (1, 2, "m");
INSERT INTO "courses_modules" (course_id, module_id, type) VALUES
        (1, 3, "m");
INSERT INTO "courses_modules" (course_id, module_id, type) VALUES
        (1, 4, "m");
INSERT INTO "courses_modules" (course_id, module_id, type) VALUES
        (1, 5, "m");
INSERT INTO "courses_modules" (course_id, module_id, type) VALUES
        (1, 6, "m");
INSERT INTO "courses_modules" (course_id, module_id, type) VALUES
        (1, 7, "m");
INSERT INTO "courses_modules" (course_id, module_id, type) VALUES
        (1, 8, "e");
INSERT INTO "courses_modules" (course_id, module_id, type) VALUES
        (1, 9, "m");
INSERT INTO "courses_modules" (course_id, module_id, type) VALUES
        (1, 10, "m");
INSERT INTO "courses_modules" (course_id, module_id, type) VALUES
        (1, 11, "e");
INSERT INTO "courses_modules" (course_id, module_id, type) VALUES
        (1, 12, "m");
INSERT INTO "courses_modules" (course_id, module_id, type) VALUES
        (1, 13, "m");
INSERT INTO "courses_modules" (course_id, module_id, type) VALUES
        (1, 14, "m");
INSERT INTO "courses_modules" (course_id, module_id, type) VALUES
        (1, 15, "m");

-- generates too many records for a single insert statement
INSERT INTO "modules_focus_areas" (module_id, focus_area_id) values
        (1, 2);
INSERT INTO "modules_focus_areas" (module_id, focus_area_id) values
        (2, 2);
INSERT INTO "modules_focus_areas" (module_id, focus_area_id) values
        (3, 2);
INSERT INTO "modules_focus_areas" (module_id, focus_area_id) values
        (4, 2);
INSERT INTO "modules_focus_areas" (module_id, focus_area_id) values
        (5, 2);
INSERT INTO "modules_focus_areas" (module_id, focus_area_id) values
        (6, 2);
INSERT INTO "modules_focus_areas" (module_id, focus_area_id) values
        (7, 2);
INSERT INTO "modules_focus_areas" (module_id, focus_area_id) values
        (8, 2);
INSERT INTO "modules_focus_areas" (module_id, focus_area_id) values
        (9, 2);
INSERT INTO "modules_focus_areas" (module_id, focus_area_id) values
        (10, 2);
INSERT INTO "modules_focus_areas" (module_id, focus_area_id) values
        (11, 2);
INSERT INTO "modules_focus_areas" (module_id, focus_area_id) values
        (12, 2);
INSERT INTO "modules_focus_areas" (module_id, focus_area_id) values
        (13, 2);
INSERT INTO "modules_focus_areas" (module_id, focus_area_id) values
        (14, 2);
INSERT INTO "modules_focus_areas" (module_id, focus_area_id) values
        (15, 2);

INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 1, 1, 1, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 1, 1, 2, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 1, 1, 3, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 2, 1, 4, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 2, 1, 5, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 2, 1, 6, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 3, 1, 7, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 3, 1, 8, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 3, 1, 9, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 4, 2, 10, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 4, 2, 11, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 5, 2, 12, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 5, 2, 13, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 6, 2, 14, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 6, 2, 15, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 6, 2, 16, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 7, 3, 17, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 7, 3, 18, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 8, 3, 19, "e");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 8, 3, 20, "e");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 9, 3, 21, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 9, 3, 22, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 9, 3, 23, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 10, 4, 24, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 10, 4, 25, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 11, 4, 26, "e");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 11, 4, 27, "e");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 11, 4, 28, "e");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 12, 4, 29, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 12, 2, 29, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 12, 2, 30, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 13, 5, 32, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 13, 5, 33, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 14, 5, 34, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 14, 5, 35, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 15, 5, 36, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 15, 5, 37, "m");
INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES
        (1, 15, 5, 38, "m");
