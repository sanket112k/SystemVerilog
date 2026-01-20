module FunctionForkExample_tb;

    // This task is time-consuming (blocking within its own thread)
    task automatic time_consuming_task(int delay_val, string name);
        $display("[%0t ns] TASK (%s): Starting delay of %0d ns...", $time, name, delay_val);
        #(delay_val); // This statement blocks ONLY this task's thread
        $display("[%0t ns] TASK (%s): ...Finished delay.", $time, name);
    endtask

    // This function runs instantly (cannot contain '#' or '@')
    // but it initiates other processes using fork...join_none
    function automatic void initiate_background_processes();
        $display("[%0t ns] FUNCTION: Execution begins instantly.", $time);
        
        // Use fork...join_none to spawn child threads in parallel
        fork
            // Call the time-consuming task
            time_consuming_task(5, "Process_A");
            
            // Call another instance of the task
            time_consuming_task(10, "Process_B");
            
            // Or use inline blocking statements
            begin
                #2;
                $display("[%0t ns] FUNCTION_INLINE_PROCESS: Woke up after 2 ns.", $time);
            end
        join_none; // Crucial: This makes the fork block non-blocking to the parent scope.

        $display("[%0t ns] FUNCTION: Execution finishes instantly. Main thread moved on.", $time);
    endfunction

    initial begin
        $display("[%0t ns] INITIAL BLOCK: Simulation started.", $time);
        
        // Call the function. It executes immediately and returns control 
        // while the forked processes run in the background.
        initiate_background_processes();
        
        $display("[%0t ns] INITIAL BLOCK: Continued immediately after function returned.", $time);

        // The 'initial' block must be held open to see the background processes finish.
        // 'wait fork;' blocks the current (initial) thread until all processes started 
        // by the last 'fork...join_none' in this scope are done.
        wait fork; 
        
        $display("[%0t ns] INITIAL BLOCK: All forked processes are complete. Ending simulation.", $time);
    end

endmodule
