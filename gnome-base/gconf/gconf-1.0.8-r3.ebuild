# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gconf/gconf-1.0.8-r3.ebuild,v 1.3 2002/07/11 06:30:25 drobbins Exp $

S=${WORKDIR}/GConf-${PV}
DESCRIPTION="Gconf"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/GConf/GConf-${PV}.tar.gz"
HOMEPAGE="http://www.gnome.org/"

SLOT="1"

RDEPEND=">=sys-libs/db-3.2.3h 
	nls? ( sys-devel/gettext )"

DEPEND="${RDEPEND} 
	>=dev-util/guile-1.4
	dev-util/indent
	dev-libs/glib
	dev-libs/libxml
	dev-libs/popt
	gnome-base/oaf
	gnome-base/ORBit"

src_compile() {
	local myconf
	
	libtoolize --copy --force
	
	use nls	\
		|| myconf="--disable-nls"	\
		&& mkdir intl			\
		&& touch intl/libgettext.h

	./configure --host=${CHOST}	\
		    --prefix=/usr \
		    --sysconfdir=/etc \
		    --localstatedir=/var/lib \
		    ${myconf} || die

	make || die   # Doesn't work with -j 4 (hallski)
}

src_install() {
	make prefix=${D}/usr \
	     sysconfdir=${D}/etc \
	     localstatedir=${D}/var/lib \
	     install || die
	# gconf 1.0.8 seems to gets the perms wrong on this dir.
	chmod 0755 ${D}/etc/gconf/gconf.xml.mandatory
	# this fix closes bug #803
	dodoc AUTHORS COPYING ChangeLog NEWS README* TODO
}

pkg_postinst() {
	# this is to fix installations where the following dir
	# has already been merged with incorrect permissions.
	# We can remove this fix after gconf 1.0.8 is an ancient
	# version.
	if [ ! -e ${ROOT}/etc/gconf/gconf.xml.mandatory ]
	then
		#unmerge of older revisions nuke this one
		mkdir -p ${ROOT}/etc/gconf/gconf.xml.mandatory
	fi
	chmod 0755 ${ROOT}/etc/gconf/gconf.xml.mandatory
}
