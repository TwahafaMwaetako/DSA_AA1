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
        // Display the menu options to the user
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

        // Read the user's choice
        string choice = io:readln();

        match choice {
            "1" => {
                check addProgramme(programmeClient);
            }
            "2" => {
                check retrieveAllProgrammes(programmeClient);
            }
            "3" => {
                check updateProgramme(programmeClient);
            }
            "4" => {
                check retrieveSpecificProgramme(programmeClient);
            }
            "5" => {
                check deleteProgramme(programmeClient);
            }
            "6" => {
                check retrieveProgrammesDueForReview(programmeClient);
            }
            "7" => {
                check retrieveProgrammesByFaculty(programmeClient);
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

function addProgramme(http:Client programmeClient) returns error? {
    Programme|error newProgramme = inputProgramme();
    if (newProgramme is Programme) {
        // Send a POST request
        Programme|error response = programmeClient->/programmes.post(newProgramme);
        if (response is error) {
            io:println("Error adding programme: ", response.message());
        } else {
            io:println("Programme added successfully: ", response);
        }
    } else {
        io:println("Invalid input for programme details. Please try again.");
    }
    return;
}

function retrieveAllProgrammes(http:Client programmeClient) returns error? {
    Programme[] allProgrammes = check programmeClient->/programmes;
    io:println("All programmes:");
    foreach Programme programme in allProgrammes {
        io:println("----------------------------------------");
        io:println("Programme Code: ", programme.programmeCode);
        io:println("NQF Level: ", programme.nqfLevel);
        io:println("Faculty: ", programme.faculty);
        io:println("Department: ", programme.department);
        io:println("Qualification Title: ", programme.qualificationTitle);
        io:println("Registration Date: ", programme.registrationDate);
        io:println("Courses: ");
        foreach Course course in programme.courses {
            io:println("  - Course Name: ", course.name);
            io:println("    Code: ", course.code);
            io:println("    NQF Level: ", course.nqfLevel);
        }
    }
    return;
}

function updateProgramme(http:Client programmeClient) returns error? {
    io:println("Enter programme code to update:");
    string programmeCode = io:readln();

    // Check if the programme exists
    Programme|error checkResult = programmeClient->/programmes/[programmeCode];
    if checkResult is http:ClientRequestError {
        io:println("HTTP error occurred: ", checkResult.message());
        io:println("Status code: ", checkResult.detail().statusCode);
        io:println("Error details: ", checkResult.detail());
        return;
    } else if checkResult is error {
        io:println("Programme does not exist, Please try again ");
        return;
    }

    // If we reach here, the programme exists, so proceed with update
    Programme|error updatedProgramme = inputProgramme();
    if updatedProgramme is Programme {
        Programme|error result = programmeClient->/programmes/[programmeCode].put(updatedProgramme);
        if result is error {
            io:println("Error updating programme: ", result.message());
            io:println("Error details: ", result.detail());
        } else {
            io:println("Updated programme: ", result);
        }
    } else {
        io:println("Invalid input for programme details. Please try again.");
    }
    return;
}

function retrieveSpecificProgramme(http:Client programmeClient) returns error? {
    io:println("Enter programme code to retrieve:");
    string programmeCode = io:readln();

    Programme|error retrievedProgramme = programmeClient->/programmes/[programmeCode];

    if retrievedProgramme is error {
        if (retrievedProgramme is http:ClientRequestError) {
            io:println("HTTP error occurred while retrieving programme: ", retrievedProgramme.message());
            io:println("Status code: ", retrievedProgramme.detail().statusCode);
            io:println("Error details: ", retrievedProgramme.detail());
        } else {
            io:println("Programme does not exist: ", programmeCode);
            io:println("Error message: ", retrievedProgramme.message());
        }
    } else {
        io:println("----------------------------------------");
        io:println("Programme Code: ", retrievedProgramme.programmeCode);
        io:println("NQF Level: ", retrievedProgramme.nqfLevel);
        io:println("Faculty: ", retrievedProgramme.faculty);
        io:println("Department: ", retrievedProgramme.department);
        io:println("Qualification Title: ", retrievedProgramme.qualificationTitle);
        io:println("Registration Date: ", retrievedProgramme.registrationDate);
        io:println("Courses: ");
        foreach Course course in retrievedProgramme.courses {
            io:println("  - Course Name: ", course.name);
            io:println("    Code: ", course.code);
            io:println("    NQF Level: ", course.nqfLevel);
        }
    }
    return;
}

function deleteProgramme(http:Client programmeClient) returns error? {
    io:println("Enter programme code to delete:");
    string programmeCode = io:readln();

    // Log the request
    io:println("Sending request to delete programme with code: ", programmeCode);

    // Attempt to delete the programme
    string|error deleteResponse = programmeClient->delete("/programmes/" + programmeCode);

    // Check the response
    if deleteResponse is error {
        if (deleteResponse is http:ClientRequestError) {
            io:println("HTTP error occurred while deleting programme: ", deleteResponse.message());
            io:println("Status code: ", deleteResponse.detail().statusCode);
            if deleteResponse.detail().statusCode == 404 {
                io:println("Programme does not exist: ", programmeCode);
            }
        } else {
            io:println("Programme does not exist: ", programmeCode);
        }
    } else {
        // If deletion was successful
        io:println(deleteResponse); // This should print "Programme deleted successfully"
    }
    return;
}


function retrieveProgrammesDueForReview(http:Client programmeClient) returns error? {
    Programme[] reviewProgrammes = check programmeClient->/programmes/review;
    io:println("Programmes due for review:");
    foreach Programme programme in reviewProgrammes {
        io:println("----------------------------------------");
        io:println("Programme Code: ", programme.programmeCode);
        io:println("NQF Level: ", programme.nqfLevel);
        io:println("Faculty: ", programme.faculty);
        io:println("Department: ", programme.department);
        io:println("Qualification Title: ", programme.qualificationTitle);
        io:println("Registration Date: ", programme.registrationDate);
    }
    return;
}

function retrieveProgrammesByFaculty(http:Client programmeClient) returns error? {
    io:println("Enter faculty name:");
    string facultyName = io:readln();

    // Retrieve all programmes to check for faculty existence
    Programme[] allProgrammes = check programmeClient->/programmes;

    // Check if the faculty exists in the list of all programmes
    boolean facultyExists = false;
    foreach Programme programme in allProgrammes {
        if programme.faculty == facultyName {
            facultyExists = true;
            break;
        }
    }

    if (!facultyExists) {
        io:println("Faculty does not exist: ", facultyName);
    } else {
        // Retrieve programmes by faculty
        Programme[] facultyProgrammes = check programmeClient->/programmes/faculty/[facultyName];

        // Check if there are any programmes under this faculty
        if facultyProgrammes.length() == 0 {
            io:println("No programmes found under the faculty: ", facultyName);
        } else {
            io:println("Programmes in ", facultyName, " faculty:");
            foreach Programme programme in facultyProgrammes {
                io:println("----------------------------------------");
                io:println("Programme Code: ", programme.programmeCode);
                io:println("NQF Level: ", programme.nqfLevel);
                io:println("Department: ", programme.department);
                io:println("Qualification Title: ", programme.qualificationTitle);
                io:println("Registration Date: ", programme.registrationDate);
                io:println("Courses: ");
                foreach Course course in programme.courses {
                    io:println("  - Course Name: ", course.name);
                    io:println("    Code: ", course.code);
                    io:println("    NQF Level: ", course.nqfLevel);
                }
            }
        }
    }
    return;
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
