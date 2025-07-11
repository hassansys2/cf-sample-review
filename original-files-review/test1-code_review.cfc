component {

    /**
     * Retrieves a user by their ID.
     * @param userID The ID of the user to retrieve.
     * @param dsn The datasource name.
     * @return A struct containing user details or an empty struct if not found.
     */
    public struct function getUserByID(numeric userID, required string dsn) {
        var userRecord = {};
        var sql = "
            SELECT
                UserID,
                UserName,
                EmailAddress
            FROM
                Users
            WHERE
                UserID = :userID
        ";

        var qryResult = queryExecute(
            sql,
            { userID: { value: arguments.userID, cfsqltype: "cf_sql_integer" } },
            { datasource: arguments.dsn }
        );

        if (qryResult.RecordCount > 0) {
            userRecord.userID = qryResult.USERID[1];
            userRecord.username = qryResult.USERNAME[1];
            userRecord.emailAddress = qryResult.EmailAddress[1];
        }

        return userRecord;
    }

    /**
     * Retrieves a user by their username.
     * @param Username The username of the user to retrieve.
     * @param dsn The datasource name.
     * @return A struct containing user details or an empty struct if not found.
     */
    public struct function getUserByUsername(string Username, required string dsn) {
        var userData = {};
        var sql = "
            SELECT
                UserID,
                UserName,
                EmailAddress
            FROM
                Users
            WHERE
                UserName = '#arguments.Username#'
        ";

        var qryResult = queryExecute(
            sql,
            {}, // Missing parameters for Username
            { datasource: arguments.dsn }
        );

        if (qryResult.recordcount > 0) {
            userData.UserID = qryResult.USERID[1];
            userData.UserName = qryResult.USERNAME[1];
            userData.emailAddress = qryResult.EmailAddress[1];
        }

        return userData;
    }
}