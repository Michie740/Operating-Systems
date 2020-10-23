#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Node {
  int data;
  struct Node *next;
};

struct Node *listInsertTail(struct Node *head, int data);
struct Node *mergeLists(struct Node *l1, struct Node *l2);
void printList(struct Node *head);

int main(int argc, char *argv[]) {
  struct Node *list1 = NULL;
  struct Node *list2 = NULL;
  int i = 1;
  char *errorMsg = "Pass in arguments in the format: <list 1 ints seperated by spaces> "
    ", <list 2 ints seperated by spaces>"; 
  if (argc == 1) {
    puts(errorMsg);
    return 1;
  }
  while (strcmp(argv[i], ",")) {
    list1 = listInsertTail(list1, atoi(argv[i]));
    i++;
    if (!argv[i]) {
      puts(errorMsg);
      return 1;
    }
  }
  i++;
  while (argv[i] != NULL) {
    list2 = listInsertTail(list2, atoi(argv[i]));
    i++;
  }

  struct Node *list3 = mergeLists(list1, list2);
  printList(list2);
  printList(list1);
  printList(list3);

}

// Add new node to the end of the linked list (also in class slides)
struct Node *listInsertTail(struct Node *head, int data) {
  struct Node *tail = head;
  struct Node *new = malloc(sizeof(struct Node));

  // In the event that we we're passed NULL, we initialize a new list
  if (tail == NULL) {
    new->next = NULL;
    new->data = data;
    return new;
  }

  // Iterate down the list to the tail
  while (tail->next != NULL) {
    tail = tail->next;
  }

  // Set our fields
  new->data = data;
  new->next = NULL;
  tail->next = new;

  return head;
}


void printList(struct Node *head) {
  if (head == NULL) {
    return;
  }
  struct Node *curr = head;
  while (curr->next != NULL) {
    printf("%d->", curr->data);
    curr = curr->next;
  }
  printf("%d \n", curr->data);
}


struct Node *mergeLists(struct Node *l1, struct Node *l2) {
  /*
   TODO fill in code here
  */

  if (l1 == NULL && l2 == NULL) return 0;
  else if (l1 == NULL) return l2;
  else if (l2 == NULL) return l1;
  else{
    struct Node *merged = NULL;
    while (1){
      if(l1 != NULL && l2 != NULL){
        if (l1->data <= l2->data){
          listInsertTail(merged, l1->data);
          l1 = l1->next;
        }
        else{
          listInsertTail(merged, l2->data);
          l2 = l2->next;
        }
      }
      else if (l1 == NULL && l2 != NULL){
        listInsertTail(merged, l2->data);
        l2 = l2-> next;
      }
      else if (l2 == NULL && l1 != NULL){
        listInsertTail(merged, l1->data);
        l1 = l1-> next;
      }
      else {
        return merged;
        break;
      }
    }
  }
  return 0;
}
