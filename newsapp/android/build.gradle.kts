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

    // --- ĐOẠN CODE SỬA LỖI NAMESPACE ---
    afterEvaluate {
        if (project.extensions.findByName("android") != null) {
            val android = project.extensions.getByName("android")
            try {
                // Kiểm tra và tự động gán namespace nếu bị thiếu
                val getNamespace = android.javaClass.getMethod("getNamespace")
                val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)

                if (getNamespace.invoke(android) == null) {
                    val nameSpace = "dev.isar.${project.name.replace("-", ".")}"
                    setNamespace.invoke(android, nameSpace)
                }
            } catch (e: Exception) {
                // Bỏ qua nếu plugin không hỗ trợ hoặc có lỗi phản chiếu (reflection)
            }
        }
    }
    // ----------------------------------
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}