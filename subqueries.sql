SELECT channel, AVG(event_count)
FROM
(SELECT DATE_TRUNC('DAY', occurred_at) AS DAY,
		 channel,
		 COUNT(*) AS event_count
	FROM web_events
	GROUP BY 1,2
	ORDER BY 1
	) sub
GROUP BY 1
ORDER BY 2 DESC