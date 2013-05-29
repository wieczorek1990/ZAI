CREATE TABLE "appointments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "date" date, "start" datetime, "end" datetime, "clinic_doctor_id" integer, "patient_id" integer, "confirmed_at" datetime, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "clinic_doctors" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "clinic_id" integer, "doctor_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "clinics" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "roles" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "resource_id" integer, "resource_type" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255) DEFAULT '' NOT NULL, "encrypted_password" varchar(255) DEFAULT '' NOT NULL, "reset_password_token" varchar(255), "reset_password_sent_at" datetime, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar(255), "last_sign_in_ip" varchar(255), "confirmation_token" varchar(255), "confirmed_at" datetime, "confirmation_sent_at" datetime, "unconfirmed_email" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "type" varchar(255), "first_name" varchar(255), "last_name" varchar(255), "pesel" varchar(255), "address" varchar(255), "postal_code" varchar(255), "city" varchar(255), "pzw" varchar(255));
CREATE TABLE "users_roles" ("user_id" integer, "role_id" integer);
CREATE TABLE "work_plans" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "day" integer, "start" datetime, "end" datetime, "clinic_doctor_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_appointments_on_clinic_doctor_id_and_patient_id" ON "appointments" ("clinic_doctor_id", "patient_id");
CREATE UNIQUE INDEX "index_clinic_doctors_on_clinic_id_and_doctor_id" ON "clinic_doctors" ("clinic_id", "doctor_id");
CREATE INDEX "index_roles_on_name" ON "roles" ("name");
CREATE INDEX "index_roles_on_name_and_resource_type_and_resource_id" ON "roles" ("name", "resource_type", "resource_id");
CREATE UNIQUE INDEX "index_users_on_confirmation_token" ON "users" ("confirmation_token");
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email");
CREATE UNIQUE INDEX "index_users_on_reset_password_token" ON "users" ("reset_password_token");
CREATE INDEX "index_users_roles_on_user_id_and_role_id" ON "users_roles" ("user_id", "role_id");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20120519151537');

INSERT INTO schema_migrations (version) VALUES ('20120519153208');

INSERT INTO schema_migrations (version) VALUES ('20120519153314');

INSERT INTO schema_migrations (version) VALUES ('20120519153859');

INSERT INTO schema_migrations (version) VALUES ('20120519154341');

INSERT INTO schema_migrations (version) VALUES ('20120526084002');

INSERT INTO schema_migrations (version) VALUES ('20120526085416');

INSERT INTO schema_migrations (version) VALUES ('20120526145755');

INSERT INTO schema_migrations (version) VALUES ('20120526153832');

INSERT INTO schema_migrations (version) VALUES ('20120526154555');

INSERT INTO schema_migrations (version) VALUES ('20120526193526');

INSERT INTO schema_migrations (version) VALUES ('20120527145254');