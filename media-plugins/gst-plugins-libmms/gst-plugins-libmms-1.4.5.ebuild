# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-libmms/gst-plugins-libmms-1.4.5.ebuild,v 1.3 2015/03/15 11:16:58 pacho Exp $

EAPI="5"
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE=""

RDEPEND=">=media-libs/libmms-0.6.2-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
