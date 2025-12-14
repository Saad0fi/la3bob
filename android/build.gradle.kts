



allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    project.afterEvaluate {
        
        // التحقق من وجود الامتداد (Extension) الخاص بـ Android
        project.extensions.findByName("android")?.let { androidExtension ->
            // تحويل الامتداد إلى النوع الأساسي (BaseExtension)
            (androidExtension as? com.android.build.gradle.BaseExtension)?.apply {
                
                if (namespace == null) {
                    namespace = project.group.toString()
                }
                
                compileSdkVersion(36)

                // فرض Java 11 على Java Compiler
                compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_11
                    targetCompatibility = JavaVersion.VERSION_11
                }

                // فرض JVM Target 11 لـ Kotlin Compiler
                project.tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
                    kotlinOptions {
                        jvmTarget = "11"
                    }
                }
            }
        }
    }
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}



