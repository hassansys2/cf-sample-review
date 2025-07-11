component {

    /**
     * Retrieves recent activity records and enriches them with the associated username.
     * @param maxActivities The maximum number of recent activities to retrieve.
     * @param dsn The datasource name.
     * @return An array of structs, each representing an activity with user details.
     */
    public array function getRecentActivitiesWithUsernames(numeric maxActivities, required string dsn) {
        var activitiesWithUsers = [];

        var qryRecentActivities = queryExecute(
            "SELECT ActivityID, UserID, ActivityType, ActivityDate
            FROM Activities
            ORDER BY ActivityDate DESC
            LIMIT :maxActivities",
            { maxActivities: { value: arguments.maxActivities, cfsqltype: "cf_sql_integer" } },
            { datasource: arguments.dsn }
        );

        for (var i = 1; i <= qryRecentActivities.recordcount; i++) {
            var activity = {
                activityID = qryRecentActivities.ActivityID[i],
                userID = qryRecentActivities.UserID[i],
                activityType = qryRecentActivities.ActivityType[i],
                activityDate = qryRecentActivities.ActivityDate[i],
                userName = ""
            };

            var qryUser = queryExecute(
                "SELECT UserName FROM Users WHERE UserID = :userID",
                { userID: { value: activity.userID, cfsqltype: "cf_sql_integer" } },
                { datasource: arguments.dsn }
            );

            if (qryUser.recordcount > 0) {
                activity.userName = qryUser.UserName[1];
            } else {
                activity.userName = "Unknown User";
            }

            arrayAppend(activitiesWithUsers, activity);
        }

        return activitiesWithUsers;
    }
}