# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/bonobo/bonobo-1.0.22.ebuild,v 1.22 2004/12/16 11:03:46 corsair Exp $

inherit gnome.org libtool gnuconfig

DESCRIPTION="A set of language and system independent CORBA interfaces"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sparc x86"
IUSE="nls"

RDEPEND=">=gnome-base/oaf-0.6.8
	=gnome-base/orbit-0*
	>=gnome-base/gnome-print-0.30
	>=media-libs/gdk-pixbuf-0.6"
DEPEND="${RDEPEND}
	dev-lang/perl
	nls? ( sys-devel/gettext
	>=dev-util/intltool-0.11 )"

src_compile() {
	#libtoolize to fix relink bug
	elibtoolize

	use ppc64 && gnuconfig_update

	local myconf=""
	use nls || myconf="${myconf} --disable-nls"

	econf ${myconf} || die

	make || die # make -j 4 didn't work
}

src_install() {
	einstall || die

	dodoc AUTHORS COPYING* ChangeLog README NEWS TODO
}
