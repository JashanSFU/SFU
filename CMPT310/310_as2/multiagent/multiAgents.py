# multiAgents.py
# --------------
# Licensing Information:  You are free to use or extend these projects for
# educational purposes provided that (1) you do not distribute or publish
# solutions, (2) you retain this notice, and (3) you provide clear
# attribution to UC Berkeley, including a link to http://ai.berkeley.edu.
# 
# Attribution Information: The Pacman AI projects were developed at UC Berkeley.
# The core projects and autograders were primarily created by John DeNero
# (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# Student side autograding was added by Brad Miller, Nick Hay, and
# Pieter Abbeel (pabbeel@cs.berkeley.edu).


# import sys
from util import manhattanDistance
from game import Directions
import random, util

from game import Agent

class ReflexAgent(Agent):
    """
    A reflex agent chooses an action at each choice point by examining
    its alternatives via a state evaluation function.

    The code below is provided as a guide.  You are welcome to change
    it in any way you see fit, so long as you don't touch our method
    headers.
    """


    def getAction(self, gameState):
        """
        You do not need to change this method, but you're welcome to.

        getAction chooses among the best options according to the evaluation function.

        Just like in the previous project, getAction takes a GameState and returns
        some Directions.X for some X in the set {NORTH, SOUTH, WEST, EAST, STOP}
        """
        # Collect legal moves and successor states
        legalMoves = gameState.getLegalActions()

        # Choose one of the best actions
        scores = [self.evaluationFunction(gameState, action) for action in legalMoves]
        bestScore = max(scores)
        bestIndices = [index for index in range(len(scores)) if scores[index] == bestScore]
        chosenIndex = random.choice(bestIndices) # Pick randomly among the best

        "Add more of your code here if you want to"

        return legalMoves[chosenIndex]

    def evaluationFunction(self, currentGameState, action):
        """
        Design a better evaluation function here.

        The evaluation function takes in the current and proposed successor
        GameStates (pacman.py) and returns a number, where higher numbers are better.

        The code below extracts some useful information from the state, like the
        remaining food (newFood) and Pacman position after moving (newPos).
        newScaredTimes holds the number of moves that each ghost will remain
        scared because of Pacman having eaten a power pellet.

        Print out these variables to see what you're getting, then combine them
        to create a masterful evaluation function.
        """
        # Useful information you can extract from a GameState (pacman.py)
        successorGameState = currentGameState.generatePacmanSuccessor(action)
        newPos = successorGameState.getPacmanPosition()
        newFood = successorGameState.getFood()
        newGhostStates = successorGameState.getGhostStates()
        newScaredTimes = [ghostState.scaredTimer for ghostState in newGhostStates]
        "*** YOUR CODE HERE ***"
        score = successorGameState.getScore()
        minimumFoodPoint = 0 
        foodList = newFood.asList()
        if len(foodList) != 0 : 
            minimumFoodPoint = util.manhattanDistance(foodList[0],newPos)
        for food in foodList:
            if (util.manhattanDistance(food, newPos) < minimumFoodPoint):
                minimumFoodPoint = util.manhattanDistance(food,newPos)
        if len(foodList) != 0:
            score = score + 1/minimumFoodPoint
        for Ghost in newGhostStates:
            distance = util.manhattanDistance(Ghost.getPosition(), newPos)    
            if distance <= 1: 
                    score = float('-inf')
            elif distance < 3:
                    score = - abs(score)*10
        return score

def scoreEvaluationFunction(currentGameState):
    """
    This default evaluation function just returns the score of the state.
    The score is the same one displayed in the Pacman GUI.

    This evaluation function is meant for use with adversarial search agents
    (not reflex agents).
    """
    return currentGameState.getScore()

class MultiAgentSearchAgent(Agent):
    """
    This class provides some common elements to all of your
    multi-agent searchers.  Any methods defined here will be available
    to the MinimaxPacmanAgent, AlphaBetaPacmanAgent & ExpectimaxPacmanAgent.

    You *do not* need to make any changes here, but you can if you want to
    add functionality to all your adversarial search agents.  Please do not
    remove anything, however.

    Note: this is an abstract class: one that should not be instantiated.  It's
    only partially specified, and designed to be extended.  Agent (game.py)
    is another abstract class.
    """

    def __init__(self, evalFn = 'scoreEvaluationFunction', depth = '2'):
        self.index = 0 # Pacman is always agent index 0
        self.evaluationFunction = util.lookup(evalFn, globals())
        self.depth = int(depth)

class MinimaxAgent(MultiAgentSearchAgent):
    """
    Your minimax agent (question 2)
    """

    def getAction(self, gameState):
        """
        Returns the minimax action from the current gameState using self.depth
        and self.evaluationFunction.

        Here are some method calls that might be useful when implementing minimax.

        gameState.getLegalActions(agentIndex):
        Returns a list of legal actions for an agent
        agentIndex=0 means Pacman, ghosts are >= 1

        gameState.generateSuccessor(agentIndex, action):
        Returns the successor game state after an agent takes an action

        gameState.getNumAgents():
        Returns the total number of agents in the game

        gameState.isWin():
        Returns whether or not the game state is a winning state

        gameState.isLose():
        Returns whether or not the game state is a losing state
        """
        "*** YOUR CODE HERE ***"
        rtnValue = self.valueOfState(gameState, 0, 0)
        return rtnValue[1]
    
    def valueOfState(self, gameState, depth, index):
        if len(gameState.getLegalActions(index)) == 0 or depth == self.depth:
            return self.evaluationFunction(gameState), ""
        
        ReturningActions = []
        ActionsForAgent = gameState.getLegalActions(index)
        
        if( index == 0 ):
            nextIndex = index+1
            if(nextIndex == gameState.getNumAgents()): 
                nextIndex = 0 
                depth = depth + 1  
            maxValue = float('-inf')
            maxAgentAction = ""
            for agentAction in ActionsForAgent:
                successorValue = self.valueOfState(gameState.generateSuccessor(index, agentAction), depth , nextIndex) # rough sketch
                if successorValue[0] > maxValue:
                    maxValue = successorValue[0]
                    maxAgentAction = agentAction
            return maxValue, maxAgentAction
        else :
            nextIndex = index+1
            if(nextIndex == gameState.getNumAgents()): 
                nextIndex = 0 
                depth = depth + 1   
            minValue = float('inf')
            for agentAction in ActionsForAgent:
                successorValue = self.valueOfState(gameState.generateSuccessor(index, agentAction), depth, nextIndex) # rough sketch
                if successorValue[0] < minValue:
                    minValue = successorValue[0]
                    minAgentAction = agentAction
            return minValue, minAgentAction

class AlphaBetaAgent(MultiAgentSearchAgent):
    """
    Your minimax agent with alpha-beta pruning (question 3)
    """

    def getAction(self, gameState):
        """
        Returns the minimax action using self.depth and self.evaluationFunction
        """
        "*** YOUR CODE HERE ***"
        rtnValue = self.valueOfState(gameState, 0, 0, float('-inf'), float('inf'))
        return rtnValue[1]
    
    def valueOfState(self, gameState, depth, index, alpha , beta):
        if len(gameState.getLegalActions(index)) == 0 or depth == self.depth:
            return self.evaluationFunction(gameState), ""
        
        ReturningActions = []
        ActionsForAgent = gameState.getLegalActions(index)
        
        if( index == 0 ):
            nextIndex = index+1
            if(nextIndex == gameState.getNumAgents()): 
                nextIndex = 0 
                depth = depth + 1  
            maxValue = float('-inf')
            maxAgentAction = ""
            for agentAction in ActionsForAgent:
                successorValue = self.valueOfState(gameState.generateSuccessor(index, agentAction), depth , nextIndex, alpha, beta) # rough sketch
                if successorValue[0] > maxValue:
                    maxValue = successorValue[0]
                    maxAgentAction = agentAction
                if maxValue > beta: return maxValue, agentAction
                alpha = max(maxValue, alpha)
            return maxValue, maxAgentAction
        else :
            nextIndex = index+1
            if(nextIndex == gameState.getNumAgents()): 
                nextIndex = 0 
                depth = depth + 1   
            minValue = float('inf')
            for agentAction in ActionsForAgent:
                successorValue = self.valueOfState(gameState.generateSuccessor(index, agentAction), depth, nextIndex,alpha, beta) # rough sketch
                if successorValue[0] < minValue:
                    minValue = successorValue[0]
                    minAgentAction = agentAction
                if minValue < alpha: return minValue, agentAction
                beta = min(minValue, beta)
            return minValue, minAgentAction
        
class ExpectimaxAgent(MultiAgentSearchAgent):
    """
      Your expectimax agent (question 4)
    """

    def getAction(self, gameState):
        """
        Returns the expectimax action using self.depth and self.evaluationFunction

        All ghosts should be modeled as choosing uniformly at random from their
        legal moves.
        """
        "*** YOUR CODE HERE ***"
        rtnValue = self.valueOfState(gameState, 0, 0)
        return rtnValue[1]
    
    def valueOfState(self, gameState, depth, index):
        if len(gameState.getLegalActions(index)) == 0 or depth == self.depth:
            return self.evaluationFunction(gameState), ""
        
        ReturningActions = []
        ActionsForAgent = gameState.getLegalActions(index)
        
        if( index == 0 ):
            nextIndex = index+1
            if(nextIndex == gameState.getNumAgents()): 
                nextIndex = 0 
                depth = depth + 1  
            maxValue = float('-inf')
            maxAgentAction = ""
            for agentAction in ActionsForAgent:
                successorValue = self.valueOfState(gameState.generateSuccessor(index, agentAction), depth , nextIndex) # rough sketch
                if successorValue[0] > maxValue:
                    maxValue = successorValue[0]
                    maxAgentAction = agentAction
            return maxValue, maxAgentAction
        else :
            nextIndex = index+1
            if(nextIndex == gameState.getNumAgents()): 
                nextIndex = 0 
                depth = depth + 1   
            avgValue = 0
            for agentAction in ActionsForAgent:
                successorValue = self.valueOfState(gameState.generateSuccessor(index, agentAction), depth, nextIndex) # rough sketch
                avgValue = avgValue + successorValue[0] * (1/len(ActionsForAgent))
            return avgValue,""
def betterEvaluationFunction(currentGameState):
    """
    Your extreme ghost-hunting, pellet-nabbing, food-gobbling, unstoppable
    evaluation function (question 5).

    DESCRIPTION: <write something here so we know what you did>
    """
    "*** YOUR CODE HERE ***"
    successorGameState = currentGameState
    newPos = successorGameState.getPacmanPosition()
    newFood = successorGameState.getFood()
    newGhostStates = successorGameState.getGhostStates()
    newScaredTimes = [ghostState.scaredTimer for ghostState in newGhostStates]
    "*** YOUR CODE HERE ***"
    score = successorGameState.getScore()
    minimumFoodPoint = 0 
    foodList = newFood.asList()
    if len(foodList) != 0 : 
        minimumFoodPoint = util.manhattanDistance(foodList[0],newPos)
    
    for food in foodList:
        if (util.manhattanDistance(food, newPos) < minimumFoodPoint):
            minimumFoodPoint = util.manhattanDistance(food,newPos)
    if len(foodList) != 0:
        score = score + 1/minimumFoodPoint
    for index , Ghost in enumerate(newGhostStates):
        distance = util.manhattanDistance(Ghost.getPosition(), newPos)    
        if distance <= 1:
            if (newScaredTimes[index] == 0): 
                score = float('-inf')
        elif distance < 3:
            if (newScaredTimes[index] == 0):
                score = - abs(score)*40
    return score

# Abbreviation
better = betterEvaluationFunction
