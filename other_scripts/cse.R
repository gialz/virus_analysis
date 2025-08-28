library(tidyfast)
library(data.table)

#
cov = fread("~/Desktop/leafcutter_perind.counts.gz")
cov = cov %>% 
  melt(id.vars = c("chrom")) %>% 
  dt_separate(value,into =  c("junction_count", "cluster_count"), sep = '/') 

cov = cov %>% 
  mutate(variable = gsub(".SJ.out.tab","",variable)) %>% 
  rename(sample = variable) %>% 
  mutate(junction_count = as.numeric(junction_count),cluster_count = as.numeric(cluster_count)) %>% 
  dt_separate(chrom,into =  c("seqname", "start","end",'cluster'), sep = ':') %>% 
  mutate(strand = stringr::str_sub(cluster,-1,-1))

cov = cov %>% 
  mutate(start = as.numeric(start) - 1,
         end = as.numeric(end) + 1) %>% 
  mutate(junction = paste0(seqname,":",start,"-",end))


meta_cov = fread('~/Desktop/internship/practice/virtus2/covid_metadata_cleaned.csv')

cryptic_detection_summary_long_version = fread('~/downloads/cryptic_detection_summary_long_version.csv')
cov %>% 
  filter(junction %in% cryptic_detection_summary_long_version$paste_into_igv_junction) %>% 
  left_join(cryptic_detection_summary_long_version,by = c("junction" = "paste_into_igv_junction")) %>% 
  filter(junction_count >0) %>% 
  arrange(-junction_count) %>% 
  filter(fpr_value < 0.1) %>% 
  distinct(sample,junction_count,cluster_count,gene_name,junction)
  # left_join(meta_cov,by = c('sample' = 'Accession')) %>% 
  # mutate(psi = junction_count/cluster_count) %>% filter(Title == 'ICUVENT6') %>% View()
  
cov