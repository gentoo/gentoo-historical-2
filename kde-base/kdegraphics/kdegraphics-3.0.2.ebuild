# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdegraphics/kdegraphics-3.0.2.ebuild,v 1.2 2002/07/11 06:30:26 drobbins Exp $

inherit  kde-dist

DESCRIPTION="${DESCRIPTION}Graphics"

newdepend "gphoto2? ( >=media-gfx/gphoto2-2.0_beta1 >=media-libs/libgpio-20010607 )
	    sys-devel/perl
	    media-gfx/sane-backends
	    tetex? ( >=app-text/tetex-1.0.7 )
	    media-libs/imlib"

use gphoto2	&& myconf="$myconf --with-kamera --with-gphoto2-includes=/usr/include/gphoto2 \
				   --with-gphoto2-libraries=/usr/lib/gphoto2 \
				   --with-gpio --with-gpio-includes=/usr/include \
				   --with-gpio-libraries=/usr/lib" || myconf="$myconf --without-kamera"

use tetex 	&& myconf="$myconf --with-system-kpathsea --with-tex-datadir=/usr/share"

myconf="$myconf --with-imlib --with-imlib-config=/usr/bin "

