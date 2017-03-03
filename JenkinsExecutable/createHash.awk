#!/bin/awk -f
BEGIN{
    OFS=FS=","
    split(source,src_fields,FS)           
    for (i in src_fields)                  
        field_src[src_fields[i]] = i
    split(target,tgt_fields,FS)           
    for (i in tgt_fields)                  
        field_tgt[tgt_fields[i]] = i 
}

NR==1 {                                # Process header
    for (i=1;i<=NF;i++)                # For each field header
        head[i] = $i                   # Add to hash for comparision with target
	next                           # Skip to next line
}
{                                      
    sep=""                             # Set for leading separator
    for (i=1;i<=NF;i++)  {              # For each field
        if (head[i] in field_src) {    # Test for current field is a source field
            printf "%s%s",sep,$i	# print the array to be captured in bash array
    }
	if (head[i] in field_tgt) {    # Test for current field is a target field
            printf "%s%s",sep,$i	#print the value to be captured in bash array
    }
  }
  printf ","
	
      
}
