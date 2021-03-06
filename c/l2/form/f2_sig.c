#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "list.h"
#include "lang.h"
#include "xcl.h"
#include "ilem_form.h"
#include "f2.h"
#include "npool.h"

#ifndef strdup
extern char *strdup(const char *);
#endif

static unsigned char *
sig_one(struct f2 *fp, int tail)
{
  unsigned char buf[1024];
  char *oform = NULL, *lang_no_script = NULL;
#if 0
  if (fp->oform)
    {
      oform = malloc(strlen(fp->oform) + 3);
      sprintf(oform,"~~%s",fp->oform);
    }
#endif

  if (!strstr((const char *)fp->lang, "-949"))
    lang_no_script = tag_no_script((const char*)fp->lang);

  sprintf((char*)buf,"@%s%%%s:%s%s=%s[%s//%s]%s'%s",
	  fp->project,
	  lang_no_script ? lang_no_script : (char*)fp->lang,
	  tail ? (Uchar*)"" : fp->form,
	  oform ? oform : "",
	  fp->cf ? fp->cf : (Uchar*)"X",
	  fp->gw ? fp->gw : (Uchar*)"X",
	  fp->sense ? fp->sense : (Uchar*)"X",
	  fp->pos ? fp->pos : (Uchar*)"X",
	  fp->epos ? fp->epos : (Uchar*)"X");

  if (lang_no_script)
    free(lang_no_script);

  if (fp->norm)
      sprintf((char*)(buf+strlen((char*)buf)),"$%s",fp->norm);

  if (fp->base)
    sprintf((char*)(buf+strlen((char*)buf)),"/%s",fp->base);

  if (fp->cont)
    sprintf((char*)(buf+strlen((char*)buf)),"+%s",fp->cont);

  if (fp->morph)
    sprintf((char*)(buf+strlen((char*)buf)),"#%s",fp->morph);

  if (fp->morph2)
    sprintf((char*)(buf+strlen((char*)buf)),"##%s",fp->morph2);

  if (oform)
    free(oform);

  return (unsigned char *)strdup((char*)buf);
}

unsigned char *
f2_sig(struct f2 *fp, struct npool*pool)
{
  unsigned char *ret = NULL;

  if (!fp)
    return NULL;

  if (fp->parts)
    {
      unsigned char *tmp = NULL;
      tmp = sig_one(fp, 0);
      if (tmp) 
	{
	  List *parts = list_create(LIST_SINGLE);
	  int i;
	  list_add(parts, tmp);
	  for (i = 0; fp->parts[i]; ++i)
	    {
	      fp->parts[i]->tail_sig = tmp = sig_one(fp->parts[i], 1);
	      if (tmp)
		list_add(parts, tmp);
	      else
		return NULL;
	    }
	  tmp = list_to_str2(parts, "&&");
	  ret = npool_copy(tmp,pool);
	  free(tmp);
	}
      else
	return NULL;
    }
  else
    {
      unsigned char *tmp = NULL;
      tmp = sig_one(fp, 0);
      ret = npool_copy(tmp,pool);
      free(tmp);
    }

  return ret;
}

#if 0
static void
append_sig_sans_form(unsigned char *buf,unsigned char *sig)
{
  unsigned char *dst = buf+strlen((char*)buf);
  while (*sig && ':' != *sig)
    *dst++ = *sig++;
  *dst++ = *sig++;
  while (*sig && '=' != *sig)
    ++sig;
  while (*sig)
    *dst++ = *sig++;
  *dst = '\0';
}
#endif

static char *
tabless(const unsigned char *s)
{
  static char buf[1024], *tab;
  strcpy(buf,(char*)s);
  tab = strchr(buf,'\t');
  if (tab)
    *tab = '\0';
  return buf;
}

unsigned char *
f2_psu_sig(struct f2 *fp, struct npool *pool)
{
  unsigned char buf[1024];

#if 1
  sprintf((char*)buf,"{%s}::",fp->psu_ngram);
#else
  sprintf((char*)buf,"{%s[%s//%s]%s'%s",
	  fp->cf ? fp->cf : (Uchar*)"X",
	  fp->gw ? fp->gw : (Uchar*)"X",
	  fp->sense ? fp->sense : (Uchar*)"X",
	  fp->pos ? fp->pos : (Uchar*)"X",
	  fp->epos ? fp->epos : (Uchar*)"X");
  strcat((char*)buf, "}::");
#endif
  
  if (fp->parts)
    { 
      int i;
      char *amp = NULL;
      for (i = 0; fp->parts[i]; ++i)
	{
	  if (i)
	    strcat((char*)buf, "++");

#if 1
	  if (fp->parts[i]->tail_sig)
	    strcat((char*)buf, (char*)fp->parts[i]->tail_sig);
	  else
	    {
	      if (!fp->parts[i]->sig)
		fp->parts[i]->sig = f2_sig(fp->parts[i], pool);

	      if ((amp = strstr((char*)fp->parts[i]->sig, "&&")))
		{
		  int len = strlen((char*)buf) + (amp - (char*)fp->parts[i]->sig);
		  strncat((char*)buf, (char*)fp->parts[i]->sig, amp - (char*)fp->parts[i]->sig);
		  buf[len] = '\0';
		}
	      else
		strcat((char*)buf,tabless(fp->parts[i]->sig));
#else
	      if (BIT_ISSET(fp->parts[i]->flags, F2_FLAGS_SAME_REF))
		append_sig_sans_form(buf,(unsigned char*)tabless(fp->parts[i]->sig));
	      else
		strcat((char*)buf,tabless(fp->parts[i]->sig));
#endif
	    }
	}
    }
  return npool_copy(buf,pool);
}
