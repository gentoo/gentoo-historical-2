# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/mkisofs/mkisofs-1.13-r2.ebuild,v 1.2 2002/04/27 21:33:32 seemant Exp $
# -r2 by Dan Armak

S=${WORKDIR}/${P}
DESCRIPTION="Premastering program for creating iso9660 volumes"
SRC_URI="ftp://ftp.fokus.gmd.de/pub/unix/cdrecord/mkisofs/${P}.tar.gz"
HOMEPAGE="http://www.fokus.gmd.de/research/cc/glone/employees/joerg.schilling/private/mkisofs.html"

src_install() {							   
	
	into /usr
	
	[ -d mkisofs/OBJ/i686-linux-cc ] && DIR=i686-linux-cc
	[ -d mkisofs/OBJ/i586-linux-cc ] && DIR=i586-linux-cc
	[ -d mkisofs/OBJ/i486-linux-cc ] && DIR=i486-linux-cc
	[ -d mkisofs/OBJ/i386-linux-cc ] && DIR=i386-linux-cc
	
	dobin mkisofs/OBJ/${DIR}/mkisofs
	dobin mkisofs/diag/OBJ/${DIR}/devdump
	dobin mkisofs/diag/OBJ/${DIR}/isodump
	dobin mkisofs/diag/OBJ/${DIR}/isoinfo
	dobin mkisofs/diag/OBJ/${DIR}/isovfy
	
	doman mkisofs/mkisofs.8 mkisofs/mkhybrid.8 mkisofs/apple_driver.8
	doman mkisofs/diag/isoinfo.8
	dodoc ABOUT BUILD COMPILE COPYING MKNOD* PORTING README*
	docinto mkisofs
	dodoc mkisofs/ChangeLog
	dodoc mkisofs/README* mkisofs/TODO
	
}
