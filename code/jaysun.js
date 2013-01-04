/**
 * jQuery JAYSUN Based on JSONFormatter by github.com/forward
 * Original Developed by: github.com/forward
 * Modified version by André Figueira github.com/andrefigueira
 *
 * This script is free software: you can redistribute it and/or modify it 
 * under the terms of the GNU General Public License as published by the Free 
 * Software Foundation, either version 3 of the License, or (at your option)
 * any later version.
 */ 
 $.fn.Jaysun = function(options){
    
    var defaults = {
      'listID' : 'json',
      'collapse' : false,
      'closed': false,
      'closeIcon': ' &#9658; ',
      'openIcon': ' &#9660; ',
      'resultElement': '#' + $(this).attr('id')
    }
    
    var options = $.extend(defaults, options);
    
    var loopCount = 0;
    
    //Get the string content from the object instanced
    var jsonStr = $(this).html();
    
    //Parse the string into a json obj
	var json = $.parseJSON(jsonStr);
    
    var loopObjectOfObjects = function(json2, ulId) 
    {
    
      $.each(json2, function(k3, v3){
      
        // object of objects
        if(typeof v3 == 'object'){
        
          $(options.resultElement + ' #' + options.listID + ' #' + ulId).append('<li><span>{</span> <ul id="' + ulId + '-' + k3 + '"></ul></li>');
          
          $.each(v3, function(k4, v4){
          
            if(typeof v4 == 'object' && v4 != null) 
            {
            
              $(options.resultElement + ' #' + options.listID + ' #' + ulId + '-' + k3).append('<li>' + k4 + ' <span>{</span> <ul id="' + k4 + '-' + loopCount + '"></ul></li>');
              loopAgain(v4, k4, k4 + '-' + loopCount);
            
            }
            else 
            {
            
              $(options.resultElement + ' #' + options.listID + ' #' + ulId + '-' + k3).append('<li>' + k4 + ': ' + v4 + '</li>');
              
            }

          });
          
        } 
        else 
        {
        
          // normal array
          $(options.resultElement + ' #' + options.listID + ' #' + ulId).append('<li>' + v3 + '</li>');
          
        }
        
      });
      
    }

    var loopAgain = function(v, k, ulId){
    
      loopCount++;
      
      $.each(v, function(nextKey, nextVal){
      
        var nextListId = nextKey + '-' + loopCount;
        var newList = '<ul id="' + nextListId + '"></ul>';
        
        if(nextVal != null && typeof nextVal == 'object') 
        {
        
          if(nextVal.length == 0)
          {
          
            // an empty object, just output that
            $(options.resultElement + ' #' + options.listID + ' #' + ulId).append('<li><i>' + nextKey + ':</i> {}</li>');
            
          } 
          else if(nextVal.length >= 1)
          {
          
            // an object of objects
            $(options.resultElement + ' #' + options.listID + ' #' + ulId).append('<li><b>' + nextKey + ':</b> <span>{</span> ' + newList + '</li>');
            loopObjectOfObjects(nextVal, nextListId);
            
          }
          else if(nextVal.length == undefined) 
          {
          
            // next node
            $(options.resultElement + ' #' + options.listID + ' #' + ulId).append('<li><b>' + nextKey + ':</b> <span>{</span> ' + newList + '</li>');
            loopAgain(nextVal, nextKey, nextListId);
            
          }  
                
        }
        else
        {
        
            $(options.resultElement + ' #' + options.listID + ' #' + ulId).append('<li><i>'+ nextKey + ':</i> ' + nextVal + '</li>');
            
        }
        
      });
      
    }
    
    var addClosingBraces = function()
    {
    
      $(options.resultElement + ' #' + options.listID + ' span').each(function(){
      
        var closingBrace = '<span>}</span>';
        
        if($(this).text() == "{")
        {
        
          closingBrace = '<span>}</span>';
          
        }
        
        $(this).parent().find('ul').eq(0).after(closingBrace);
        
      });
            
    }

    var jsonList = $('<ul id="' + options.listID + '" />');

    $(this).html(jsonList);

    $.each(json, function(key, val){
      
      if(val != null && typeof val == 'object') 
      {
      
        var goObj = false;
        var goArray = false;
        var nk = '';
        
        $.each(val, function(nextKey, nextVal){
        
          if(nextVal != null && typeof nextVal == 'object') 
          {
          
            if(nextVal.length == undefined) 
            {
            
              goObj = true;
              nk = nextKey;
              
            }
            else 
            {
            
              goObj = false;
              
            }
            
          }
          else 
          {
          
            goArray = true;
            
          }
          
        });

        if(goObj) 
        {
        
          $(options.resultElement + ' #' + options.listID).append('<li><b>' + key + ':</b> <span>{</span><ul id="' + nk + '-' + loopCount + '"></ul></li>');
          loopObjectOfObjects(val, nk + '-' + loopCount);
        
        }
        else if(goArray) 
        {
        
          $(options.resultElement + ' #' + options.listID).append('<li><b>' + key + ':</b> <span>{</span><ul id="' + nk + '-' + loopCount + '"></ul></li>');
          loopAgain(val, nk, nk + '-' + loopCount);
          
        }
        else 
        {
        
          $(options.resultElement + ' #' + options.listID).append('<li><b>' + key + ':</b> <span>{</span><ul id="' + key + '-' + loopCount + '"></ul></li>');
          loopAgain(val, key, key + '-' + loopCount);  
                      
        }
        
      }
      else 
      {
      
        $(options.resultElement + ' #' + options.listID).append('<li><i>' + key + ':</i> ' + val + '</li>');
        
      }
      
    });
  
	var addToggles = function(listId, options)
	{
	
		$(options.resultElement + ' #' + listId + " > li").find('ul').each(function(){
		
		  $(this).parent().find('span').eq(0).before('<span class="toggle fake-link"> ' + options.openIcon + ' </span>');
		  
		});
		
		if(options.closed == true)
		{
		    
		    $('.toggle').next().next().hide();
		    $('.toggle').html(options.closeIcon);
		    
		}
		
		$('.toggle').live('click', function() {
		
		  if($(this).next().next().is(':visible'))
		  {
		  
		    $(this).next().next().hide();
		    $(this).html(options.closeIcon);
		    
		  }
		  else 
		  {
		  
		    $(this).next().next().show();
		    $(this).html(options.openIcon);
		    
		  }
		  
		});
	
	}
    
	addClosingBraces();
	
	if(options.collapse) 
	{
	
	  addToggles(options.listID, options);      
	  
	}

}