Here are a few example scripts that may be helpful for getting the data into usable form

### Helpful Function

But first, here's a function I wrote for myself and use very often at work. A StringIO object acts essentially like a FileObject, except it's stored in memory (i.e., the data isn't written to disk). I've made slight tweaks for it to be better suited for the purposes of things on this Slack, but be sure to edit the `profile_name` as needed.
```python
import boto3
from cStringIO import StringIO

ses = boto3.session.Session(profile_name='d4d')
s3 = ses.resource('s3')
# if you configured your aws cli with the default profile, remove the above to lines and uncomment the following line 
#s3 = boto3.resource('s3')

def to_StringIO(key, bucket_name = 'data-for-democracy', s3 = s3):
    obj = s3.Object(bucket_name, key)
    return StringIO(obj.get()['Body'].read())
```

After you have the data in the StringIO object, you can more or less treat it the same as you would a FileObject. The main exception you'll likely run into is the need to call `.seek(0)` after you've read out the data from it (that's just setting the buffer to point to the front of the chunk of memory it's stored in).

### S3 into Pandas DataFrame (Python)

Pulling data into a data frame (assuming the code above prefaces the below):
```python
import pandas as pd

key = 'voter-fraud/openelections-data/openelections-data-tx/2016/20160126__tx__special__general__runoff.csv'
f = to_StringIO(key=key)
df = pd.read_csv(f)
```

*(Add something about feather here...)*
