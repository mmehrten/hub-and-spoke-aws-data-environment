import json, os


def get_revoke_list():
    os.system(
        "aws lakeformation list-permissions | jq -r '.PrincipalResourcePermissions' > tmp.json"
    )
    with open("tmp.json", "r") as f:
        data = json.load(f)
    return [
        i
        for i in data
        if ":group/" in i["Principal"].get("DataLakePrincipalIdentifier", "")
    ]


revoke = get_revoke_list()
while revoke:
    for idx, i in enumerate(revoke):
        revoke[idx]["Id"] = str(idx)
    for idx in range(0, len(revoke), 20):
        with open(f"revoke_{idx}.json", "w") as f:
            json.dump(
                {"CatalogId": "908971990554", "Entries": revoke[idx : idx + 20]}, f
            )
        os.system(
            f"aws lakeformation batch-revoke-permissions --cli-input-json file://revoke_{idx}.json"
        )
    revoke = get_revoke_list()
os.system("rm *.json")
