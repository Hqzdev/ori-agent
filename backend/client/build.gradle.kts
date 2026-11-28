java {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}
// Keep the existing client package and DTO types available to Android and Windows consumers.
val clientV3Sources by tasks.registering(Sync::class) {
    from("../core/src/main/java/dev/ori/core/v3") {
        into("dev/blot/core/v3")
        filter { line: String -> line.replace("dev.ori.core.v3", "dev.blot.core.v3") }
    }
    into(layout.buildDirectory.dir("generated/sources/client-v3/java"))
}
sourceSets.main { java.srcDir(clientV3Sources) }
sourceSets.test { resources.srcDir(rootProject.file("../fixtures/v3")) }
configure<com.diffplug.gradle.spotless.SpotlessExtension> {
    java { target("src/**/*.java") }
}
dependencies {
    api(libs.jackson)
    implementation("com.fasterxml.jackson.datatype:jackson-datatype-jsr310:2.20.0")
}
