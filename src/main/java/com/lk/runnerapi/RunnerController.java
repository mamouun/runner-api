package com.lk.runnerapi;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@CrossOrigin
@RestController
@ResponseBody
public class RunnerController {

    @RequestMapping("/get-runners")
    public List<Runner> getRunners() {
        Runner runner = new Runner("Amine", "Courbevoie");
        Runner runner2 = new Runner("Hamza", "Creteil");
        Runner runner3 = new Runner("Jacques", "Paris");
        Runner runner4 = new Runner("Fred", "Paris");
        List<Runner> runners = new ArrayList<>();
        runners.add(runner);
        runners.add(runner2);
        runners.add(runner3);
        runners.add(runner4);
        return runners;
    }
}
