ENTRY(_start)
    
SECTIONS
{
    .text : {
    *(.text.start .text.start.*)
    *(.text)
    }

    .data : {
    *(.data)
    }

    .bss : {
    *(.bss)
    }
}