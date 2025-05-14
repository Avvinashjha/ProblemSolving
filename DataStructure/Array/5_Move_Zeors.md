Given an integer array `nums`, move all `0`'s to the end of it while maintaining the relative order of the non-zero elements.

**Note** that you must do this in-place without making a copy of the array.

**Example 1:**

```
**Input:** nums = \[0,1,0,3,12\]
**Output:** \[1,3,12,0,0\]
```
**Example 2:**

```
**Input:** nums = \[0\]
**Output:** \[0\]
```
Approach 1:

- Read all no zero value and store in a list then replace the nums with stored list and 

Approach 2: 2 Pointer Approach
- One Pointer to track the left most zeros and other to process the array
```java
public void moveZeroes(int[] nums) {
        int pointer = -1;
        for(int i =0; i< nums.length; i++){
            if(pointer >= 0 && nums[i] != 0){
                nums[pointer] = nums[i];
                nums[i] = 0;
                pointer++;
            }else if(nums[i] == 0 && pointer < 0){
                pointer = i;
            }
        }
        
    }
```
