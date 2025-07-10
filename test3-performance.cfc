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
            "SELECT a.ActivityID, a.UserID, a.ActivityType, a.ActivityDate, u.UserName
            FROM Activities a
            LEFT JOIN Users u ON a.UserID = u.UserID
            ORDER BY a.ActivityDate DESC
            LIMIT :maxActivities",
            { maxActivities: { value: arguments.maxActivities, cfsqltype: "cf_sql_integer" } },
            { datasource: arguments.dsn }
        );

        for (var i = 1; i <= qryRecentActivities.recordCount; i++) {
            var activity = {
                activityID = qryRecentActivities.ActivityID[i],
                userID = qryRecentActivities.UserID[i],
                activityType = qryRecentActivities.ActivityType[i],
                activityDate = qryRecentActivities.ActivityDate[i],
                userName = isNull(qryRecentActivities.UserName[i]) ? "Unknown User" : qryRecentActivities.UserName[i]
            };

            arrayAppend(activitiesWithUsers, activity);
        }

        return activitiesWithUsers;
    }
}