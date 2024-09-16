import ballerina/http;
import ballerina/time;

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

map<Programme> programmes = {};

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
        if (!programmes.hasKey(programmeCode)) {
            return error("Programme not found");
        }
        return programmes.get(programmeCode);
    }

    resource function delete [string programmeCode]() returns string|error {
        if (!programmes.hasKey(programmeCode)) {
            return error("Programme not found");
        }
        _ = programmes.remove(programmeCode);
        return "Programme deleted successfully";
    }

    resource function get review() returns Programme[] {
        time:Civil currentTime = time:utcToCivil(time:utcNow());
        return programmes.toArray().filter(function(Programme p) returns boolean {
            time:Civil|error registrationDate = time:civilFromString(p.registrationDate);
            if (registrationDate is error) {
                return false;
            }
            int yearsDiff = currentTime.year - registrationDate.year;
            if (yearsDiff > 5) {
                return true;
            } else if (yearsDiff == 5) {
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