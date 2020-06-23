/* Random generation */
static unsigned long int next = 1; //the seed

int rand1(unsigned int val_max)
{
    next = next * 1103515245 + 12345;
    return (unsigned int)(next / 65536) % (val_max + 1);
}

void srand1(unsigned int seed)
{
    next = seed;
}

