-- ���ڴ� DEVONthink �������ҵĲ����еġ�ÿ���ղ���������£����磺https://blanboom.org/2019/201904/
-- �ο������½ű���http://forum.eastgate.com/t/script-to-export-certain-devonthink-metadata-in-a-tsv-for-tinderbox-import/1105

-- ����ƥ�� DEVONthink �����µ� tag�������·��ں��ʵķ����£��ɸ���ʵ�������޸�
-- ���һ�����ַ�������ƥ��δ�� tag �����£���Ҫɾ��
property tagList : {"������", "����", "Making", "�۵�", "����", "��Ϸ", "����", ""}

tell application id "DNtp"
	try
		set theSelection to the selection
		if theSelection is {} then error "��ѡ����Ҫ���ɵ��ĵ�"
		set theFile to choose file name default name "ÿ���ղ������.markdown"
		
		set theMarkdown to my createMarkdown(theSelection)
		set thePath to POSIX path of theFile
		if thePath does not end with ".markdown" then set thePath to thePath & ".markdown"
		
		do shell script "echo " & quoted form of theMarkdown & ">" & quoted form of thePath
		
		hide progress indicator
	on error error_message number error_number
		hide progress indicator
		if the error_number is not -128 then display alert "DEVONthink Pro" message error_message as warning
	end try
end tell

on createMarkdown(theseRecords)
	local these_records_before, these_records_after
	local current_tag
	local this_record, this_markdown, this_tags, this_name, this_URL, this_comment
	tell application id "DNtp"
		set this_markdown to ""
		
		set these_records_before to {}
		set these_records_after to theseRecords
		
		repeat with current_tag in tagList
			
			-- ��һ��ѭ����ֻ����δ������� record
			set these_records_before to these_records_after
			set these_records_after to {}
			
			-- ����һ������
			set current_tag to current_tag as string
			
			if current_tag is equal to "" then
				set this_markdown to this_markdown & "# ����" & return & return
			else
				set this_markdown to this_markdown & "# " & current_tag & return & return
			end if
			
			repeat with this_record in these_records_before
				set this_tags to (tags of this_record) as string
				
				if (this_tags contains current_tag) or (current_tag is equal to "") then
					
					-- ���±���
					set this_name to name of this_record as string
					
					-- Ϊ���±����������
					set this_URL to URL of this_record as string
					if this_URL begins with "http" then
						set this_name to "[" & this_name & "](" & this_URL & ")"
					end if
					
					-- Ϊ���±�����Ӷ�Ӧ�ĸ�ʽ
					set this_markdown to this_markdown & "- **" & this_name & "**" & return & return
					
					-- ���ע��
					set this_comment to comment of this_record as string
					if this_comment is not equal to "" then
						set this_markdown to this_markdown & this_comment & return & return
					end if
				else
					set end of these_records_after to this_record
				end if
			end repeat
		end repeat
	end tell
	return this_markdown
end createMarkdown