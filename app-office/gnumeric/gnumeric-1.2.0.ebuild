# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/gnumeric/gnumeric-1.2.0.ebuild,v 1.1 2003/09/17 20:19:32 liquidx Exp $

#provide Xmake and Xemake
inherit virtualx libtool gnome2 eutils debug

DESCRIPTION="Gnumeric, the GNOME Spreadsheet"
HOMEPAGE="http://www.gnome.org/gnome-office/gnumeric.shtml"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

# evolution, perl, guile and gb support disabled currently (or to be removed)

# FIXME : should rethink gda/gnomedb USE stuff

IUSE="libgda gnomedb python bonobo"

RDEPEND=">=x11-libs/gtk+-2
	>=dev-libs/glib-2
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/libgnomeprint-2.2
	>=gnome-base/libgnomeprintui-2.2
	>=gnome-base/libgnomecanvas-2
	>=gnome-base/libglade-2
	>=dev-libs/libxml2-2.4.12
	>=gnome-extra/libgsf-1.8.2
	>=media-libs/libart_lgpl-2.3.11
	python? ( >=dev-lang/python-2
		>=dev-python/pygtk-1.99.10 )
	libgda? ( >=gnome-extra/libgda-0.90 )
	bonobo? ( >=gnome-base/libbonobo-2.2
		>=gnome-base/libbonoboui-2.2 )"
#	gnomedb? ( >=gnome-extra/libgnomedb-0.90.2 )

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.27.2
	dev-util/pkgconfig"

src_unpack() {

	unpack ${A}
	gnome2_omf_fix

	cd ${S}
	# fixes a sandbox issue - foser <foser@gentoo.org>
	epatch ${FILESDIR}/${P}-fix_doc_destdir_install.patch

}

src_compile() {

	econf \
		`use_with bonobo` \
		`use_with python` \
		`use_with libgda gda` \
		|| die
	# `use_with gnomedb gda`

	#the build process have to be able to connect to X
	Xemake || die
}

DOCS="AUTHORS COPYING* ChangeLog HACKING NEWS README TODO"

USE_DESTDIR="1"

