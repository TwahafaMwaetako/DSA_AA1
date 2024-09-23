import ballerina/http;
import ballerina/time;
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

// Initialize the map with some default programmes and courses.
map<Programme> programmes = {
    "CS101": {
        programmeCode: "CS101",
        nqfLevel: "7",
        faculty: "Faculty of Science",
        department: "Department of Computer Science",
        qualificationTitle: "Bachelor of Science in Computer Science",
        registrationDate: "2021-09-01T00:00:00Z",
        courses: [
            {
                name: "Data Structures and Algorithms",
                code: "CS201",
                nqfLevel: "7"
            },
            {
                name: "Operating Systems",
                code: "CS202",
                nqfLevel: "7"
            }
        ]
    },
    "ME102": {
        programmeCode: "ME102",
        nqfLevel: "8",
        faculty: "Faculty of Engineering",
        department: "Department of Mechanical Engineering",
        qualificationTitle: "Bachelor of Science in Mechanical Engineering",
        registrationDate: "2018-09-01T00:00:00Z",
        courses: [
            {
                name: "Thermodynamics",
                code: "ME301",
                nqfLevel: "8"
            },
            {
                name: "Fluid Mechanics",
                code: "ME302",
                nqfLevel: "8"
            }
        ]
    }
};

service /programmes on new http:Listener(8080) {

    resource function post .(@http:Payload Programme programme) returns Programme|error {
        if (programmes.hasKey(programme.programmeCode)) {
            return error("Programme with this code already exists");
        }
        
        time:Civil|error registrationDate = time:civilFromString(programme.registrationDate);
        if (registrationDate is error) {
            return error("Invalid date format. Use ISO 8601 format (e.g., '2024-09-16T00:00:00Z')");
        }
        
        programmes[programme.programmeCode] = programme;
        return programme;
    }

    resource function get .() returns Programme[] {
        return programmes.toArray();
    }

    resource function put [string programmeCode](@http:Payload Programme updatedProgramme) returns Programme|error {
        if (!programmes.hasKey(programmeCode)) {
            return error("Programme not found");
        }
        programmes[programmeCode] = updatedProgramme;
        return updatedProgramme;
    }

    resource function get [string programmeCode]() returns Programme|error {
        io:println("Received GET request for programme code: ", programmeCode);
        if (!programmes.hasKey(programmeCode)) {
            io:println("Programme not found: ", programmeCode);
            return error("Programme not found");
        }
        io:println("Returning programme: ", programmeCode);
        return programmes.get(programmeCode);
    }

    resource function delete [string programmeCode]() returns string|error {
        if (!programmes.hasKey(programmeCode)) {
            return error("Programme does not exist: " + programmeCode);
        }
        _ = programmes.remove(programmeCode);
        return "Programme deleted successfully";
    }


    resource function get review() returns Programme[] {
        time:Civil currentTime = time:utcToCivil(time:utcNow());
        io:println("Current date: ", currentTime);
        
        return programmes.toArray().filter(function(Programme p) returns boolean {
            time:Civil|error registrationDate = time:civilFromString(p.registrationDate);
            if (registrationDate is error) {
                return false;
            }

            int yearsDiff = currentTime.year - registrationDate.year;
            io:println("Programme: ", p.programmeCode, ", Registration Date: ", registrationDate, ", Years Difference: ", yearsDiff);

            // Check if the programme is due for review
            if (yearsDiff > 5) {
                return true;
            } else if (yearsDiff == 5) {
                // If it's exactly 5 years, check month and day to see if it's due for review
                if (currentTime.month > registrationDate.month) {
                    return true;
                } else if (currentTime.month == registrationDate.month) {
                    return currentTime.day >= registrationDate.day;
                }
            }
            return false;
        });
    }

    resource function get faculty/[string facultyName]() returns Programme[] {
        return programmes.toArray().filter(function(Programme p) returns boolean {
            return p.faculty == facultyName;
        });
    }
}