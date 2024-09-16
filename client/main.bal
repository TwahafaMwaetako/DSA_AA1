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

    while (true) {
        io:println("\nProgramme Management System");
        io:println("1. Add a new programme");
        io:println("2. Retrieve all programmes");
        io:println("3. Update an existing programme");
        io:println("4. Retrieve a specific programme");
        io:println("5. Delete a programme");
        io:println("6. Retrieve programmes due for review");
        io:println("7. Retrieve programmes by faculty");
        io:println("8. Exit");
        io:println("Enter your choice (1-8):");

        string choice = io:readln();

        match choice {
            "1" => {
                Programme newProgramme = check inputProgramme();
                Programme addedProgramme = check programmeClient->/programmes.post(newProgramme);
                io:println("Added programme: ", addedProgramme);
            }
            "2" => {
                Programme[] allProgrammes = check programmeClient->/programmes;
                io:println("All programmes: ", allProgrammes);
            }
            "3" => {
                io:println("Enter programme code to update:");
                string programmeCode = io:readln();
                Programme updatedProgramme = check inputProgramme();
                Programme result = check programmeClient->/programmes/[programmeCode].put(updatedProgramme);
                io:println("Updated programme: ", result);
            }
            "4" => {
                io:println("Enter programme code to retrieve:");
                string programmeCode = io:readln();
                Programme retrievedProgramme = check programmeClient->/programmes/[programmeCode];
                io:println("Retrieved programme: ", retrievedProgramme);
            }
            "5" => {
                io:println("Enter programme code to delete:");
                string programmeCode = io:readln();
                string deleteResult = check programmeClient->/programmes/[programmeCode].delete;
                io:println("Delete result: ", deleteResult);
            }
            "6" => {
                Programme[] reviewProgrammes = check programmeClient->/programmes/review;
                io:println("Programmes due for review: ", reviewProgrammes);
            }
            "7" => {
                io:println("Enter faculty name:");
                string facultyName = io:readln();
                Programme[] facultyProgrammes = check programmeClient->/programmes/faculty/[facultyName];
                io:println("Programmes in ", facultyName, " faculty: ", facultyProgrammes);
            }
            "8" => {
                io:println("Exiting...");
                return;
            }
            _ => {
                io:println("Invalid choice. Please try again.");
            }
        }
    }
}

function inputProgramme() returns Programme|error {
    io:println("Enter programme details:");
    io:println("Programme Code:");
    string programmeCode = io:readln();
    io:println("NQF Level:");
    string nqfLevel = io:readln();
    io:println("Faculty:");
    string faculty = io:readln();
    io:println("Department:");
    string department = io:readln();
    io:println("Qualification Title:");
    string qualificationTitle = io:readln();
    io:println("Registration Date (YYYY-MM-DDTHH:mm:ssZ):");
    string registrationDate = io:readln();

    io:println("Enter number of courses:");
    int courseCount = check int:fromString(io:readln());
    Course[] courses = [];
    foreach int i in 0 ..< courseCount {
        io:println("Course ", (i + 1), ":");
        io:println("Name:");
        string name = io:readln();
        io:println("Code:");
        string code = io:readln();
        io:println("NQF Level:");
        string courseNqfLevel = io:readln();
        courses.push({name, code, nqfLevel: courseNqfLevel});
    }

    return {
        programmeCode,
        nqfLevel,
        faculty,
        department,
        qualificationTitle,
        registrationDate,
        courses
    };
}