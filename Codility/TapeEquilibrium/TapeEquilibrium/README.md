# TapeEquilibrium 

First simple programming quiz on Codility. Done here in Objective-C, but Codility's function was C like. Used NSMakeRange and subarrayWithRange. Code (in the unit tests) is as follows


```Objective-C
int solution(NSMutableArray *A)
{

NSInteger count = A.count;
NSMutableArray* diffs = [NSMutableArray new];

for (NSInteger i = 0; i < count; i++){

NSArray* first = [A subarrayWithRange:NSMakeRange(0, i)];
NSArray* second = [A subarrayWithRange:NSMakeRange(i, count-i)];
[diffs addObject:@(abs( sum(first) - sum(second)))];

}

return minArrayValue([NSArray arrayWithArray:diffs]);
}

```

