# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/oaf/oaf-0.6.10.ebuild,v 1.24 2006/07/13 01:01:38 pvdabeel Exp $

inherit gnome.org libtool multilib

DESCRIPTION="Object Activation Framework for GNOME"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sh sparc x86"
IUSE="nls"

RDEPEND=">=dev-libs/popt-1.5
	=gnome-base/orbit-0*
	>=dev-libs/libxml-1.8.15"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	dev-util/indent
	nls? ( sys-devel/gettext )"

src_compile() {
	elibtoolize
	aclocal
	autoconf
	automake
	local myconf=""
	use nls || myconf="--disable-nls"

	./configure --host="${CHOST}"\
		--prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		--mandir=/usr/share/man \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		${myconf} || die

	emake || die
}

src_install() {
	make prefix="${D}"/usr \
		libdir="${D}"/usr/$(get_libdir) \
		mandir="${D}"/usr/share/man \
		sysconfdir="${D}"/etc \
		localstatedir="${D}"/var/lib \
		install || die

	dodoc AUTHORS ChangeLog README NEWS TODO
}
