import requests
import json
import time
from datetime import datetime, timezone


# Configuration

BASE_URL = "https://www.arbeitnow.com/api/job-board-api"
OUTPUT_FILE = "dataset/raw_jobs.json"

# Wait between API requests to respect rate limits
DELAY_SECONDS = 5

# Maximum number of retries when rate limited
MAX_RETRIES = 5

HEADERS = {
    "User-Agent": "DataAnalystJobMarketAnalysis/1.0"
}



# API Collection

all_jobs = []
page = 1

collection_time = datetime.now(timezone.utc).isoformat()

print("Starting API collection...")
print("-" * 60)

while True:

    url = f"{BASE_URL}?page={page}"
    print(f"\nCollecting page {page}...")

    retry_count = 0

    while True:

        try:
            response = requests.get(
                url,
                headers=HEADERS,
                timeout=30
            )

           
            # Handle rate limiting

            if response.status_code == 429:

                retry_count += 1

                if retry_count > MAX_RETRIES:
                    print("Maximum retries reached.")
                    raise RuntimeError(
                        "API rate limit could not be resolved."
                    )

                retry_after = response.headers.get("Retry-After")

                if retry_after:
                    wait_time = int(retry_after)
                else:
                    wait_time = 30 * retry_count

                print(
                    f"Rate limited (429). "
                    f"Waiting {wait_time} seconds..."
                )

                time.sleep(wait_time)

                continue

        
            # Handle other HTTP errors
           
            response.raise_for_status()

            break

        except requests.exceptions.RequestException as error:

            retry_count += 1

            if retry_count > MAX_RETRIES:
                raise

            wait_time = 10 * retry_count

            print(
                f"Request error: {error}"
            )

            print(
                f"Retrying in {wait_time} seconds..."
            )

            time.sleep(wait_time)


   
    # Process response

    data = response.json()

    jobs = data.get("data", [])

    all_jobs.extend(jobs)

    print(
        f"Jobs collected from page {page}: {len(jobs)}"
    )

    print(
        f"Total jobs collected: {len(all_jobs)}"
    )



    # Save progress after every page


    raw_data = {
        "source": BASE_URL,
        "collected_at_utc": collection_time,
        "last_completed_page": page,
        "total_jobs": len(all_jobs),
        "data": all_jobs
    }

    with open(
        OUTPUT_FILE,
        "w",
        encoding="utf-8"
    ) as file:

        json.dump(
            raw_data,
            file,
            ensure_ascii=False,
            indent=4
        )


    
 # Check for next page

    next_page = data.get("links", {}).get("next")

    if not next_page:
        break

    page += 1

    # Respect API rate limits
    print(
        f"Waiting {DELAY_SECONDS} seconds before next request..."
    )

    time.sleep(DELAY_SECONDS)


# Final Summary


print("\n" + "-" * 60)

print("API collection completed successfully!")

print(
    f"Total pages collected: {page}"
)

print(
    f"Total jobs collected: {len(all_jobs)}"
)

print(
    f"Collection time (UTC): {collection_time}"
)

print(
    f"Saved to: {OUTPUT_FILE}"
)