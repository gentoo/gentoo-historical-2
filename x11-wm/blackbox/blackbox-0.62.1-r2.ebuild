# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Ben Lutgens <lamer@gentoo.org>
# Modified by Matthew Jimenez
# $Header: /var/cvsroot/gentoo-x86/x11-wm/blackbox/blackbox-0.62.1-r2.ebuild,v 1.1 2002/03/15 15:06:53 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A small, fast, full-featured window manager for X"
SRC_URI="http://prdownloads.sourceforge.net/blackboxwm/${P}.tar.gz"

# Old homepage:
# HOMEPAGE="http://blackbox.alug.org/"

# This is the new home page for blackbox now that Sean Perry has taken the
# project over, but the page is currently non-existent

HOMEPAGE="http://blackboxwm.sf.net/"

DEPEND=">=x11-base/xfree-4.0
	nls? ( sys-devel/gettext )"

PROVIDE="virtual/blackbox"

src_compile() {
    local myconf
    use nls || myconf="${myconf} --disable-nls"

    ./configure --build=${CHOST} \
        --prefix=/usr \
        --sysconfdir=/etc/X11/blackbox \
        ${myconf} || die
        emake || die
}

src_install () {
    make prefix=${D}/usr \
        sysconfdir=${D}/etc/X11/blackbox \
        install || die

    dodoc ChangeLog* AUTHORS LICENSE README* TODO*
    
    exeinto /etc/X11/Sessions
    doexe $FILESDIR/blackbox
    
}

pkg_postinst() {
    #notify user about the new share dir
    if [ -d /usr/share/Blackbox ]
    then
        einfo
        einfo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        einfo "! Blackbox no longer uses /usr/share/Blackbox as the    !"
        einfo "! default share directory to contain styles and menus.  !"
        einfo "! The default directory is now /usr/share/blackbox      !"
        einfo "! Please move any files in /usr/share/Blackbox that you !"
        einfo "! wish to keep (personal styles and your menu) into the !"
        einfo "! new directory and modify your menu files to point all !"
        einfo "! listed paths to the new directory.                    !"
        einfo "! Also, be sure to update the paths in each user's      !"
        einfo "! .blackboxrc file found in their home directory.       !"
        einfo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        einfo
    fi
}

