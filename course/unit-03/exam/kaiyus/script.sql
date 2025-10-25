-- -----------------------------------------------------
-- Creación de la Base de Datos (Opcional)
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS `clinica_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `clinica_db`;

-- -----------------------------------------------------
-- Tabla: Sexos
-- Tabla catálogo para los sexos.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Sexos` (
  `id_sexo` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`id_sexo`)
);

-- -----------------------------------------------------
-- Tabla: Pacientes
-- Almacena la información de los pacientes.
-- La dirección está normalizada y CURP tiene una restricción UNIQUE.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pacientes` (
  `id_paciente` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `apellido_paterno` VARCHAR(50) NOT NULL,
  `apellido_materno` VARCHAR(50) NULL,
  `fecha_nacimiento` DATE NOT NULL,
  `curp` VARCHAR(18) NOT NULL,
  `telefono` VARCHAR(15) NULL,
  `calle_numero` VARCHAR(100) NULL,
  `colonia` VARCHAR(80) NULL,
  `ciudad` VARCHAR(80) NULL,
  `estado` VARCHAR(50) NULL,
  `codigo_postal` VARCHAR(5) NULL,
  `id_sexo` INT NOT NULL,
  PRIMARY KEY (`id_paciente`),
  UNIQUE INDEX `curp_UNIQUE` (`curp` ASC),
  CONSTRAINT `fk_Pacientes_Sexos`
    FOREIGN KEY (`id_sexo`)
    REFERENCES `Sexos` (`id_sexo`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- Tabla: Especialidades
-- Tabla catálogo para las especialidades médicas.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Especialidades` (
  `id_especialidad` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_especialidad`)
);

-- -----------------------------------------------------
-- Tabla: Medicos
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Medicos` (
  `id_medico` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `apellido_paterno` VARCHAR(50) NOT NULL,
  `apellido_materno` VARCHAR(50) NULL,
  `cedula_profesional` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id_medico`),
  UNIQUE INDEX `cedula_profesional_UNIQUE` (`cedula_profesional` ASC)
);

-- -----------------------------------------------------
-- Tabla: Medicos_especialidades
-- Tabla de unión para la relación muchos-a-muchos entre Médicos y Especialidades.
-- Se añade una clave primaria compuesta.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Medicos_especialidades` (
  `id_medico` INT NOT NULL,
  `id_especialidad` INT NOT NULL,
  PRIMARY KEY (`id_medico`, `id_especialidad`),
  CONSTRAINT `fk_Medicos_especialidades_Medicos`
    FOREIGN KEY (`id_medico`)
    REFERENCES `Medicos` (`id_medico`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Medicos_especialidades_Especialidades`
    FOREIGN KEY (`id_especialidad`)
    REFERENCES `Especialidades` (`id_especialidad`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- Tabla: Registros
-- Registros de cada consulta o ingreso. La descripción se ha hecho más específica.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registros` (
  `id_registro` INT NOT NULL AUTO_INCREMENT,
  `fecha_ingreso` DATETIME NOT NULL,
  `motivo_consulta` VARCHAR(255) NOT NULL,
  `diagnostico` TEXT NULL,
  `tratamiento_indicado` TEXT NULL,
  `id_paciente` INT NOT NULL,
  `id_medico` INT NOT NULL,
  PRIMARY KEY (`id_registro`),
  CONSTRAINT `fk_Registros_Pacientes`
    FOREIGN KEY (`id_paciente`)
    REFERENCES `Pacientes` (`id_paciente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Registros_Medicos`
    FOREIGN KEY (`id_medico`)
    REFERENCES `Medicos` (`id_medico`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- Tablas de Antecedentes (Historial Médico)
-- Estas tablas ahora se relacionan directamente con el paciente.
-- -----------------------------------------------------

-- Tabla Catálogo: Antecedentes_personales
CREATE TABLE IF NOT EXISTS `Antecedentes_personales` (
  `id_antPersonal` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id_antPersonal`)
);

-- Tabla Catálogo: Antecedentes_familiares
CREATE TABLE IF NOT EXISTS `Antecedentes_familiares` (
  `id_antFam` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id_antFam`)
);

-- Tabla de Unión: Pacientes_antecedentes_personales
CREATE TABLE IF NOT EXISTS `Pacientes_antecedentes_personales` (
  `id_paciente` INT NOT NULL,
  `id_antPersonal` INT NOT NULL,
  PRIMARY KEY (`id_paciente`, `id_antPersonal`),
  CONSTRAINT `fk_Pacientes_ant_personales_Pacientes`
    FOREIGN KEY (`id_paciente`)
    REFERENCES `Pacientes` (`id_paciente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Pacientes_ant_personales_Antecedentes`
    FOREIGN KEY (`id_antPersonal`)
    REFERENCES `Antecedentes_personales` (`id_antPersonal`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- Tabla de Unión: Pacientes_antecedentes_familiares
CREATE TABLE IF NOT EXISTS `Pacientes_antecedentes_familiares` (
  `id_paciente` INT NOT NULL,
  `id_antFam` INT NOT NULL,
  PRIMARY KEY (`id_paciente`, `id_antFam`),
  CONSTRAINT `fk_Pacientes_ant_familiares_Pacientes`
    FOREIGN KEY (`id_paciente`)
    REFERENCES `Pacientes` (`id_paciente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Pacientes_ant_familiares_Antecedentes`
    FOREIGN KEY (`id_antFam`)
    REFERENCES `Antecedentes_familiares` (`id_antFam`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- Inserción de datos iniciales (Ejemplos)
-- -----------------------------------------------------
INSERT INTO `Sexos` (`descripcion`) VALUES ('Masculino'), ('Femenino'), ('Otro');
INSERT INTO `Especialidades` (`descripcion`) VALUES ('Cardiología'), ('Medicina General'), ('Pediatría'), ('Dermatología');
INSERT INTO `Antecedentes_personales` (`descripcion`) VALUES ('Hipertensión Arterial'), ('Diabetes Mellitus Tipo 2'), ('Alergia a la Penicilina'), ('Asma');
INSERT INTO `Antecedentes_familiares` (`descripcion`) VALUES ('Antecedentes de Cáncer'), ('Antecedentes de Cardiopatía');