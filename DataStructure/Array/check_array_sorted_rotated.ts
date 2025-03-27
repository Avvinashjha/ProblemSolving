/**
 * Understanding Problem:
 * Valid cases
 * [3,4,5,1,2] --> Original: [1,2,3,4,5] --> so the array is rotated and sorted
 * [1,2,3,4,5] --> Already sorted
 * [2,2,2,3,4,,5,1,2] --> Original: [1,2,2,2,3,4,5]
 * 
 * Invalid cases
 * [3,2,5,4,1] --> This is not a valid sorted and rotated array
 * [3,1,2,3,4] --> The second 3 being before 1 breaks the original sorted order
 * 
 */

/**
 * Approach
 * 1. We observe that in a vlaid rotated sorted array, there should be at most one "decrease" (at most one place where nums[i] > nums[i+1])
 * 2. If array is already sorted then there will be no decrease
 * 3. If array is more than one decrease, then array is scambled
 */

/**
 * Checks if the given array was originally sorted in non-decreasing 
 * order and then rotated some number of times.
 * 
 * @param {number[]} nums - The input array of numbers.
 * @returns {boolean} - Returns true if the array is sorted and rotated, otherwise false.
 */
export function checkArrayIsSortedAndRoated(nums: number[]): boolean{
    let decreased = 0;
    let n = nums.length;
    for(let i = 0; i < n; i++){
        if(nums[i] > nums[(i+1) % n]){
            decreased++;
            if(decreased > 1){
                return false;
            }
        }
    }
    return true;
}
