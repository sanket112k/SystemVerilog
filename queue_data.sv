module queue_data;
string queue[$];

initial begin
  queue = {"apple", "banana", "orange"};
  $display("queue = %p",queue);

  $display("pop_front() - pop front the array element at first index position of queue: %p", queue.pop_front());
  $display("After pop front: %p", queue);
  
  $display("pop_back() - pop back the array element at last index position of queue: %p", queue.pop_back());
  $display("After pop back: %p", queue);

  queue.push_front("guava");
  $display("push_front() - After push front the elements of the  queue is : %p", queue);

  queue.push_back("lemon");
  $display("push_back() - After push back the elements of the queue is : %p", queue);
end 
endmodule

/*
OUTPUT:
queue = '{"apple", "banana", "orange"}
pop_front() - pop front the array element at first index position of queue: "apple"
After pop front: '{"banana", "orange"}
pop_back() - pop back the array element at last index position of queue: "orange"
After pop back: '{"banana"}
push_front() - After push front the elements of the  queue is : '{"guava", "banana"}
push_back() - After push back the elements of the queue is : '{"guava", "banana", "lemon"}
*/
