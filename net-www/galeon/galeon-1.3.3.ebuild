# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/galeon/galeon-1.3.3.ebuild,v 1.1 2003/03/09 20:35:38 liquidx Exp $

inherit gnome2
# inherit debug to enable debugging and do it after gnome2 so as not gnome2 notices debugging
inherit debug libtool

S="${WORKDIR}/${P}"
DESCRIPTION="A GNOME Web browser based on gecko (mozilla's rendering engine)"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://galeon.sourceforge.net"

IUSE=""
LICENSE="GPL-2"
KEYWORDS="~x86"
SLOT="0"

REQ_MOZ_VER="1.3b"

RDEPEND="virtual/x11
        >=net-www/mozilla-1.3_beta
		>=dev-libs/glib-2.0
		>=x11-libs/gtk+-2.0
		>=dev-libs/libxml2-2.4
		>=gnome-base/gconf-2.0
		>=gnome-base/ORBit2-2.0
		>=gnome-base/libbonobo-2.0
		>=gnome-base/libbonoboui-2.1.1
		>=gnome-base/bonobo-activation-2.0
		>=gnome-base/libgnomeui-2.0
		>=gnome-base/gnome-vfs-2.0
		>=gnome-base/libglade-2.0"
        
DEPEND="${RDEPEND}
    >=sys-devel/gettext-0.11"

pkg_setup () {
   if [ ! -f ${ROOT}/usr/lib/mozilla/components/libwidget_gtk2.so ]
   then
      eerror "you need mozilla-1.3+ compiled against gtk+-2"
      eerror "export USE=\"gtk2\" ;emerge mozilla -p "
      die "Need Mozilla compiled with gtk+-2.0!!"
   fi
         
}

src_compile() {
    elibtoolize
    local moz_ver="`pkg-config --modversion mozilla-xpcom | cut -d. -f1,2 2>/dev/null`"
    local myconf="--disable-werror"
    
    if [ -z "${moz_ver}" ]; then
       moz_ver=${REQ_MOZ_VER}
    fi
    myconf="${myconf} --with-mozilla-snapshot=${moz_ver}"
    
    econf ${myconf} || die "configure failed"
    make || die "compile failed"
}

DOCS="AUTHORS COPYING COPYING.README ChangeLog FAQ INSTALL README README.ExtraPrefs THANKS TODO NEWS"
