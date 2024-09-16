import ballerina/http;
import ballerina/io;

type Programme record {
    readonly string programmeCode;
    string nqfLevel;
    string faculty;
    string department;
    string qualificationTitle;
    string registrationDate;
    Course[] courses;
};

type Course record {
    string name;
    string code;
    string nqfLevel;
};

public function main() returns error? {
    http:Client programmeClient = check new ("http://localhost:8080");

    // Add a new programme
    Programme newProgramme = {
        programmeCode: "CS101",
        nqfLevel: "8",
        faculty: "Science",
        department: "Computer Science",
        qualificationTitle: "Bachelor of Computer Science",
        registrationDate: "2020-01-01T00:00:00Z",
        courses: [
            {name: "Introduction to Programming", code: "CS101", nqfLevel: "5"},
            {name: "Data Structures", code: "CS201", nqfLevel: "6"}
        ]
    };

    Programme addedProgramme = check programmeClient->/programmes.post(newProgramme);
    io:println("Added programme: ", addedProgramme);

    // Retrieve all programmes
    Programme[] allProgrammes = check programmeClient->/programmes;
    io:println("All programmes: ", allProgrammes);

    // Update an existing programme
    newProgramme.qualificationTitle = "Bachelor of Science in Computer Science";
    Programme updatedProgramme = check programmeClient->/programmes/[newProgramme.programmeCode].put(newProgramme);
    io:println("Updated programme: ", updatedProgramme);

    // Retrieve a specific programme
    Programme retrievedProgramme = check programmeClient->/programmes/[newProgramme.programmeCode];
    io:println("Retrieved programme: ", retrievedProgramme);

    // Retrieve programmes due for review
    Programme[] reviewProgrammes = check programmeClient->/programmes/review;
    io:println("Programmes due for review: ", reviewProgrammes);

    // Retrieve programmes by faculty
    Programme[] facultyProgrammes = check programmeClient->/programmes/faculty/["Science"];
    io:println("Programmes in Science faculty: ", facultyProgrammes);

    // Delete a programme
    string deleteResult = check programmeClient->/programmes/[newProgramme.programmeCode].delete;
    io:println("Delete result: ", deleteResult);
}