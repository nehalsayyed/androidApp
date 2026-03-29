allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}



subprojects {
    // 1. First, apply the Namespace fix we did earlier
    if (name == "isar_flutter_libs") {
        pluginManager.withPlugin("com.android.library") {
            extensions.configure<com.android.build.api.dsl.LibraryExtension> {
                namespace = "dev.isar.isar_flutter_libs"
            }
        }
    }

    // 2. Fix the "lStar" error by forcing a modern Compile SDK
    pluginManager.withPlugin("com.android.library") {
        extensions.configure<com.android.build.api.dsl.LibraryExtension> {
            // "lStar" was introduced in API 31. We use 34 or 35 for 2026 compatibility.
            compileSdk = 35 
        }
    }
}


