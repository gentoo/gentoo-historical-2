# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Martin Schlemmer <azarah@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-office/gnumeric/gnumeric-1.0.5-r2.ebuild,v 1.4 2002/05/23 06:50:10 seemant Exp $

#provide Xmake and Xemake

inherit virtualx

S=${WORKDIR}/${P}
DESCRIPTION="Gnumeric, the GNOME Spreadsheet"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/gnumeric/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/gnome-office/gnumeric.shtml"

#Eye Of Gnome (media-gfx/eog) is for image support.
RDEPEND="=x11-libs/gtk+-1.2*
	>=gnome-base/gnome-libs-1.4.1.2-r1
	>=gnome-base/oaf-0.6.7
	>=gnome-base/ORBit-0.5.12-r1
	>=gnome-base/libglade-0.17
	>=gnome-base/gnome-print-0.31
	>=gnome-extra/gal-0.18
	>=dev-libs/libole2-0.2.4
	>=media-gfx/eog-0.6
	=dev-libs/libxml-1.8*
	=media-libs/freetype-1.3*
	bonobo? ( >=gnome-base/bonobo-1.0.17 )
	perl?   ( >=sys-devel/perl-5.6 )
	python? ( >=dev-lang/python-2.0 )
	gb?     ( ~gnome-extra/gb-0.0.17 )
	libgda? ( >=gnome-extra/libgda-0.2.91
	          >=gnome-base/bonobo-1.0.17 )
	evo?    ( >=net-mail/evolution-0.13 )"
	 
#will only work once everybody has decided that they should support
#the latest versions of programs, or if we live in a perfect world,
#and subsequent versions do not break compatibility.
#	 guile?  ( >=dev-util/guile-1.5 )"

DEPEND="${RDEPEND}
	 nls? ( sys-devel/gettext
	 >=dev-util/intltool-0.11 )"


src_unpack() {
	unpack ${A}

	#patch 'gnumeric-doc.make' to look for files in the correct place.
	cd ${S}/doc
	patch -p0 <${FILESDIR}/${P}-docbuild.patch || die
	cd ${S}
}

src_compile() {

	# fix the relink bug, and invalid paths in .ls files.
	libtoolize --copy --force

	local myconf
	if [ -z "`use nls`" ] ; then
		myconf="--disable-nls"
	fi
  	if [ -n "`use gb`" ]; then
    		myconf="${myconf} --with-gb"
  	else
    		myconf="${myconf} --without-gb"
  	fi
	#broken as we cannot use guile-1.5 (break gnucash)
	if [ -n "`use guile`" ]; then
		myconf="${myconf} --without-guile"
	else
		myconf="${myconf} --without-guile"
	fi
  	if [ -n "`use perl`" ]; then
    		myconf="${myconf} --with-perl"
  	else
    		myconf="${myconf} --without-perl"
  	fi
  	if [ -n "`use python`" ]; then
    		myconf="${myconf} --with-python"
  	else
    		myconf="${myconf} --without-python"
  	fi
  	if [ -n "`use libgda`" ]; then
    		myconf="${myconf} --with-gda --with-bonobo"
  	else
    		myconf="${myconf} --without-gda"
  	fi
	if [ -n "`use evo`" ]; then
		myconf="${myconf} --with-evolution"
	fi
	if [ -n "`use bonobo`" ]; then
		myconf="${myconf} --with-bonobo"
	elif [ -z "`use libgda`" ]; then
		myconf="${myconf} --without-bonobo"
	fi

	CFLAGS="$CFLAGS `gdk-pixbuf-config --cflags`"

  	./configure --host=${CHOST} \
		--prefix=/usr \
		--sysconfdir=/etc \
		${myconf} || die

	#'gnumeric --dump-func-defs' needs to write to ${HOME}/.gnome/, or
	#else the build fails.
	addwrite "${HOME}/.gnome"

	#the build process have to be able to connect to X
	Xemake || Xmake || die
}	

src_install() {

  	make prefix=${D}/usr \
		sysconfdir=${D}/etc \
		install || die

  	dodoc AUTHORS COPYING *ChangeLog HACKING NEWS README TODO
}

