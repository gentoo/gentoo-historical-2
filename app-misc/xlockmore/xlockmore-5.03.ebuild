# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-misc/xlockmore/xlockmore-5.03.ebuild,v 1.1 2002/03/01 10:21:24 blocke Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Just another screensaver application for X"
SRC_URI="ftp://ftp.tux.org/pub/tux/bagleyd/xlockmore/${P}.tar.gz"
HOMEPAGE="http://www.tux.org/~bagleyd/xlockmore.html"

DEPEND="virtual/x11 media-libs/freetype
	opengl? ( virtual/opengl )
	pam? ( sys-libs/pam )
	nas? ( media-libs/nas )
	esd? ( media-libs/esound )
	motif? ( >=x11-libs/openmotif-2.1.30-r1 )
	gtk? ( x11-libs/gtk+ )"

src_compile() {

	local myconf

	use pam && myconf="--enable-pam"
	use nas || myconf="${myconf} --without-nas"
	use esd && myconf="${myconf} --with-esound"
	use opengl || myconf="${myconf} --without-opengl"
	use motif || myconf="${myconf} --without-motif"
	use gtk || myconf="${myconf} --without-gtk"

	./configure --prefix=/usr --mandir=${prefix}/man/man1 \
		--sharedstatedir=/usr/share/xlockmore --host=${CHOST} ${myconf} || die

	emake || die

	# configure script seems to suffer braindamage and doesn't setup
	# correct makefiles for these, so they are disabled for now until
	# some kind soul wants to submit a patch ;)

	#if [ "`use gtk`" ] ; then
	#	cd ${S}/xglock
	#	make all || die
	#fi

	#if [ "`use motif`" ] ; then
	#	cd ${S}/xmlock
	#	make all || die
	#fi

    
}

src_install () {

	make prefix=${D}/usr mandir=${D}/usr/man/man1 xapploaddir=${D}/usr/X11R6/lib/X11/app-defaults install || die

	exeinto /usr/bin

	# known issue: how do you tell xlock where its sounds are?
	insinto /usr/share/xlockmore
	doins sounds/*

#	use motif && doexe ${S}/xmlock/xmlock 
#	use gtk && doexe ${S}/xglock/xglock

	dodoc docs/* README 
#	use gtk && dodoc xglock/xglockrc xglock/README.xglock

}
