# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/gnumeric/gnumeric-1.1.8.ebuild,v 1.7 2003/02/13 09:16:43 vapier Exp $

#provide Xmake and Xemake
inherit virtualx libtool gnome2

DESCRIPTION="Gnumeric, the GNOME Spreadsheet"
HOMEPAGE="http://www.gnome.org/gnome-office/gnumeric.shtml"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"
IUSE="nls libgda gb evo python guile perl"

#Eye Of Gnome (media-gfx/eog) is for image support.
RDEPEND=">=x11-libs/gtk+-2
	>=dev-libs/glib-2
	>=gnome-base/libgnome-2.0.1
	>=gnome-base/libgnomeui-2.0.1
	>=gnome-base/libbonobo-2.0.0
	>=gnome-base/libbonoboui-2.0.0
	>=gnome-base/libgnomeprint-1.115.0
	>=gnome-base/libgnomeprintui-1.115.0
	>=gnome-extra/gal2-0.0.3
	=gnome-extra/libgsf-1.3.0
	>=gnome-base/libglade-2.0.0
	dev-libs/libxml2
	perl?   ( >=sys-devel/perl-5.6 )
	python? ( >=dev-lang/python-2.0 )
	gb?     ( ~gnome-extra/gb-0.0.17 )
	libgda? ( >=gnome-extra/libgda-0.2.91
	          >=gnome-base/bonobo-1.0.17 )
	evo?    ( >=net-mail/evolution-1.0.8 )"

DEPEND="${RDEPEND}
	 nls? ( sys-devel/gettext
	 >=dev-util/intltool-0.11 )"

src_compile() {
	local myconf
	use nls || myconf="--disable-nls"

	use gb \
		&& myconf="${myconf} --with-gb" \
		|| myconf="${myconf} --without-gb"

	use guile \
		&& myconf="${myconf} --with-guile" \
		|| myconf="${myconf} --without-guile"

	use perl \
		&& myconf="${myconf} --with-perl" \
		|| myconf="${myconf} --without-perl"

  	use python \
		&& myconf="${myconf} --with-python" \
		|| myconf="${myconf} --without-python"

  	econf ${myconf}

	#'gnumeric --dump-func-defs' needs to write to ${HOME}/.gnome/, or
	#else the build fails.
	# addwrite "${HOME}/.gnome"

	#the build process have to be able to connect to X
	Xemake || Xmake || die
}

src_install() {
	export GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL="1"
	make DESTDIR=${D} install || die "install failed" 

	unset GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL
}

DOCS="AUTHORS COPYING* ChangeLog HACKING NEWS README TODO"
