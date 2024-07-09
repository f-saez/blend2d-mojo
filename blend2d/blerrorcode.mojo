
alias BLResult = UInt32

alias BL_SUCCESS:BLResult = 0
alias BL_ERROR_START_INDEX:BLResult = 65536
alias BL_ERROR_OUT_OF_MEMORY:BLResult = 65536
alias BL_ERROR_INVALID_VALUE:BLResult = 65537
alias BL_ERROR_INVALID_STATE:BLResult = 65538
alias BL_ERROR_INVALID_HANDLE:BLResult = 65539
alias BL_ERROR_INVALID_CONVERSION:BLResult = 65540
alias BL_ERROR_OVERFLOW:BLResult = 65541
alias BL_ERROR_NOT_INITIALIZED:BLResult = 65542
alias BL_ERROR_NOT_IMPLEMENTED:BLResult = 65543
alias BL_ERROR_NOT_PERMITTED:BLResult = 65544
alias BL_ERROR_IO:BLResult = 65545
alias BL_ERROR_BUSY:BLResult = 65546
alias BL_ERROR_INTERRUPTED:BLResult = 65547
alias BL_ERROR_TRY_AGAIN:BLResult = 65548
alias BL_ERROR_TIMED_OUT:BLResult = 65549
alias BL_ERROR_BROKEN_PIPE:BLResult = 65550
alias BL_ERROR_INVALID_SEEK:BLResult = 65551
alias BL_ERROR_SYMLINK_LOOP:BLResult = 65552
alias BL_ERROR_FILE_TOO_LARGE:BLResult = 65553
alias BL_ERROR_ALREADY_EXISTS:BLResult = 65554
alias BL_ERROR_ACCESS_DENIED:BLResult = 65555
alias BL_ERROR_MEDIA_CHANGED:BLResult = 65556
alias BL_ERROR_READ_ONLY_FS:BLResult = 65557
alias BL_ERROR_NO_DEVICE:BLResult = 65558
alias BL_ERROR_NO_ENTRY:BLResult = 65559
alias BL_ERROR_NO_MEDIA:BLResult = 65560
alias BL_ERROR_NO_MORE_DATA:BLResult = 65561
alias BL_ERROR_NO_MORE_FILES:BLResult = 65562
alias BL_ERROR_NO_SPACE_LEFT:BLResult = 65563
alias BL_ERROR_NOT_EMPTY:BLResult = 65564
alias BL_ERROR_NOT_FILE:BLResult = 65565
alias BL_ERROR_NOT_DIRECTORY:BLResult = 65566
alias BL_ERROR_NOT_SAME_DEVICE:BLResult = 65567
alias BL_ERROR_NOT_BLOCK_DEVICE:BLResult = 65568
alias BL_ERROR_INVALID_FILE_NAME:BLResult = 65569
alias BL_ERROR_FILE_NAME_TOO_LONG:BLResult = 65570
alias BL_ERROR_TOO_MANY_OPEN_FILES:BLResult = 65571
alias BL_ERROR_TOO_MANY_OPEN_FILES_BY_OS:BLResult = 65572
alias BL_ERROR_TOO_MANY_LINKS:BLResult = 65573
alias BL_ERROR_TOO_MANY_THREADS:BLResult = 65574
alias BL_ERROR_THREAD_POOL_EXHAUSTED:BLResult = 65575
alias BL_ERROR_FILE_EMPTY:BLResult = 65576
alias BL_ERROR_OPEN_FAILED:BLResult = 65577
alias BL_ERROR_NOT_ROOT_DEVICE:BLResult = 65578
alias BL_ERROR_UNKNOWN_SYSTEM_ERROR:BLResult = 65579
alias BL_ERROR_INVALID_ALIGNMENT:BLResult = 65580
alias BL_ERROR_INVALID_SIGNATURE:BLResult = 65581
alias BL_ERROR_INVALID_DATA:BLResult = 65582
alias BL_ERROR_INVALID_STRING:BLResult = 65583
alias BL_ERROR_INVALID_KEY:BLResult = 65584
alias BL_ERROR_DATA_TRUNCATED:BLResult = 65585
alias BL_ERROR_DATA_TOO_LARGE:BLResult = 65586
alias BL_ERROR_DECOMPRESSION_FAILED:BLResult = 65587
alias BL_ERROR_INVALID_GEOMETRY:BLResult = 65588
alias BL_ERROR_NO_MATCHING_VERTEX:BLResult = 65589
alias BL_ERROR_INVALID_CREATE_FLAGS:BLResult = 65590
alias BL_ERROR_NO_MATCHING_COOKIE:BLResult = 65591
alias BL_ERROR_NO_STATES_TO_RESTORE:BLResult = 65592
alias BL_ERROR_TOO_MANY_SAVED_STATES:BLResult = 65593
alias BL_ERROR_IMAGE_TOO_LARGE:BLResult = 65594
alias BL_ERROR_IMAGE_NO_MATCHING_CODEC:BLResult = 65595
alias BL_ERROR_IMAGE_UNKNOWN_FILE_FORMAT:BLResult = 65596
alias BL_ERROR_IMAGE_DECODER_NOT_PROVIDED:BLResult = 65597
alias BL_ERROR_IMAGE_ENCODER_NOT_PROVIDED:BLResult = 65598
alias BL_ERROR_PNG_MULTIPLE_IHDR:BLResult = 65599
alias BL_ERROR_PNG_INVALID_IDAT:BLResult = 65600
alias BL_ERROR_PNG_INVALID_IEND:BLResult = 65601
alias BL_ERROR_PNG_INVALID_PLTE:BLResult = 65602
alias BL_ERROR_PNG_INVALID_TRNS:BLResult = 65603
alias BL_ERROR_PNG_INVALID_FILTER:BLResult = 65604
alias BL_ERROR_JPEG_UNSUPPORTED_FEATURE:BLResult = 65605
alias BL_ERROR_JPEG_INVALID_SOS:BLResult = 65606
alias BL_ERROR_JPEG_INVALID_SOF:BLResult = 65607
alias BL_ERROR_JPEG_MULTIPLE_SOF:BLResult = 65608
alias BL_ERROR_JPEG_UNSUPPORTED_SOF:BLResult = 65609
alias BL_ERROR_FONT_NOT_INITIALIZED:BLResult = 65610
alias BL_ERROR_FONT_NO_MATCH:BLResult = 65611
alias BL_ERROR_FONT_NO_CHARACTER_MAPPING:BLResult = 65612
alias BL_ERROR_FONT_MISSING_IMPORTANT_TABLE:BLResult = 65613
alias BL_ERROR_FONT_FEATURE_NOT_AVAILABLE:BLResult = 65614
alias BL_ERROR_FONT_CFF_INVALID_DATA:BLResult = 65615
alias BL_ERROR_FONT_PROGRAM_TERMINATED:BLResult = 65616
alias BL_ERROR_GLYPH_SUBSTITUTION_TOO_LARGE:BLResult = 65617
alias BL_ERROR_INVALID_GLYPH:BLResult = 65618
alias BL_ERROR_FORCE_UINT:BLResult = -1

# TODO : complete this with all the error messages
fn error_code(code : BLResult) -> String:
    var result = String("to be done")
    if code==BL_ERROR_START_INDEX:
        result = String("start index") 
    elif code==BL_ERROR_OUT_OF_MEMORY:
        result = String("out of memory") 
    elif code==BL_ERROR_INVALID_VALUE:
        result = String("invalid value") 
    elif code==BL_ERROR_INVALID_STATE:
        result = String("finvalid state") 
    elif code==BL_ERROR_INVALID_HANDLE:
        result = String("invalid handle") 
    elif code==BL_ERROR_INVALID_CONVERSION:
        result = String("invalid conversion") 
    elif code==BL_ERROR_OVERFLOW:
        result = String("overflow") 
    elif code==BL_ERROR_NOT_INITIALIZED:
        result = String("not initialized") 
    elif code==BL_ERROR_NOT_IMPLEMENTED:
        result = String("not implemented") 
    elif code==BL_ERROR_NOT_PERMITTED:
        result = String("not permitted") 
    elif code==BL_ERROR_IO:
        result = String("I/O") 
    elif code==BL_ERROR_BUSY:
        result = String("busy") 
    elif code==BL_ERROR_INTERRUPTED:
        result = String("interrupted") 
    elif code==BL_ERROR_TRY_AGAIN:
        result = String("try again") 
    elif code==BL_ERROR_TIMED_OUT:
        result = String("timed out") 
    elif code==BL_ERROR_BROKEN_PIPE:
        result = String("broken pipe") 
    elif code==BL_ERROR_INVALID_SEEK:
        result = String("invalid seek") 
    elif code==BL_ERROR_SYMLINK_LOOP:
        result = String("symlink loop") 
    elif code==BL_ERROR_FILE_TOO_LARGE:
        result = String("file too large") 
    elif code==BL_ERROR_ALREADY_EXISTS:
        result = String("already exists") 
    elif code==BL_ERROR_ACCESS_DENIED:
        result = String("access denied") 
    elif code==BL_ERROR_MEDIA_CHANGED:
        result = String("media changed") 
    elif code==BL_ERROR_READ_ONLY_FS:
        result = String("read only fs") 
    elif code==BL_ERROR_NO_DEVICE:
        result = String("no device") 
    elif code==BL_ERROR_NO_ENTRY:
        result = String("no entry") 
    elif code==BL_ERROR_IMAGE_TOO_LARGE:
        result = String("image too large") 
    elif code==BL_ERROR_IMAGE_NO_MATCHING_CODEC:
        result = String("no matching codec")    
    elif code==BL_ERROR_IMAGE_UNKNOWN_FILE_FORMAT:
        result = String("unknown file format")    
    elif code==BL_ERROR_IMAGE_DECODER_NOT_PROVIDED:
        result = String("decoder not provided")    
    elif code==BL_ERROR_IMAGE_ENCODER_NOT_PROVIDED:
        result = String("encoder not provided")    
    elif code==BL_ERROR_PNG_MULTIPLE_IHDR:
        result = String("PNG multiple IHDR")    
    elif code==BL_ERROR_PNG_INVALID_IDAT:
        result = String("PNG invalid DAT")    
    elif code==BL_ERROR_PNG_INVALID_IEND:
        result = String("PNG invalid IEND")    
    elif code==BL_ERROR_PNG_INVALID_PLTE:
        result = String("PNG invalid PLTE")    
    elif code==BL_ERROR_PNG_INVALID_TRNS:
        result = String("PNG invalid TRNS")    
    elif code==BL_ERROR_PNG_INVALID_FILTER:
        result = String("PNG invalid filter")    
    elif code==BL_ERROR_JPEG_UNSUPPORTED_FEATURE:
        result = String("JPEG unsupported feature")    
    elif code==BL_ERROR_JPEG_INVALID_SOS:
        result = String("JPEG invalid SOS")    
    elif code==BL_ERROR_JPEG_INVALID_SOF:
        result = String("JPEG invalid SOF")    
    elif code==BL_ERROR_JPEG_MULTIPLE_SOF:
        result = String("JPEG mutiple SOF")    
    elif code==BL_ERROR_JPEG_UNSUPPORTED_SOF:
        result = String("JPEG unsupported SOF")
    elif code==BL_ERROR_FONT_NOT_INITIALIZED:
        result = String("font not initialized")        
    elif code==BL_ERROR_FONT_NO_MATCH:
        result = String("font no match")        
    elif code==BL_ERROR_FONT_NO_CHARACTER_MAPPING:
        result = String("font no character mapping")        
    elif code==BL_ERROR_FONT_NO_CHARACTER_MAPPING:
        result = String("font no character mapping")         
    return result


