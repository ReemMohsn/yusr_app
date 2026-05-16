allprojects {
    repositories {
        google()
        mavenCentral() // 🛠️ تصحيح الدالة هنا
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    afterEvaluate {
        project.pluginManager.withPlugin("com.android.library") {
            project.extensions.configure<com.android.build.gradle.LibraryExtension>("android") {
                compileSdk = 34
                compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_17
                    targetCompatibility = JavaVersion.VERSION_17
                }
                
                // 🛠️ الطريقة المصححة والآمنة لقراءة الـ Manifest وتعيين الـ namespace
                if (namespace == null) {
                    val manifestFile = project.file("src/main/AndroidManifest.xml")
                    if (manifestFile.exists()) {
                        try {
                            val dbFactory = javax.xml.parsers.DocumentBuilderFactory.newInstance()
                            val dBuilder = dbFactory.newDocumentBuilder()
                            val doc = dBuilder.parse(manifestFile)
                            doc.documentElement.normalize()
                            val packageName = doc.documentElement.getAttribute("package")
                            if (!packageName.isNullOrEmpty()) {
                                namespace = packageName
                            }
                        } catch (e: Exception) {
                            // في حال حدوث أي خطأ أثناء القراءة لا يتوقف البناء
                        }
                    }
                }
            }
        }
    }
    
    // إجبار الجافا لجميع المكتبات على 17
    tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = JavaVersion.VERSION_17.toString()
        targetCompatibility = JavaVersion.VERSION_17.toString()
    }
    
    // إجبار الكوتلن لجميع المكتبات على 17
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}