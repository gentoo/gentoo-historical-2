# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/horde-pear/horde-pear-1.3.ebuild,v 1.2 2004/03/19 01:22:11 vapier Exp $

inherit horde

DESCRIPTION="Horde Application Framework PHP PEAR files"
HOMEPAGE="http://www.horde.org/"

KEYWORDS="x86 ~ppc ~sparc ~alpha"

DEPEND=""
RDEPEND=">=dev-php/mod_php-4.1.0
	>=sys-devel/gettext-0.10.40
	>=dev-libs/libxml2-2.4.21-r1"

S=${WORKDIR}/${HORDE_PN}

pkg_setup() { :;}

src_install() {
	dodir /usr/lib
	cp -a ${S} ${D}/usr/lib/php
}

pkg_postinst() { :;}
