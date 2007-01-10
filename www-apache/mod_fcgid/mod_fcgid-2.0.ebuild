# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_fcgid/mod_fcgid-2.0.ebuild,v 1.1 2007/01/10 19:47:38 phreak Exp $

inherit apache-module

MY_P=${PN}.${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="mod_fcgid is an binary-compatible alternative to mod_fastcgi with better process management"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
HOMEPAGE="http://fastcgi.coremail.cn/"
SRC_URI="mirror://sourceforge/mod-fcgid/${MY_P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"

APACHE2_MOD_DEFINE="FCGID"
APACHE2_MOD_CONF="20_${PN}"
APXS2_ARGS="-I ${S} -c ${PN}.c fcgid_bridge.c \
			fcgid_conf.c fcgid_pm_main.c \
			fcgid_spawn_ctl.c mod_fcgid.rc fcgid_bucket.c \
			fcgid_filter.c fcgid_protocol.c \
			arch/unix/fcgid_pm_unix.c \
			arch/unix/fcgid_proctbl_unix.c \
			arch/unix/fcgid_proc_unix.c"

DOCFILES="AUTHOR ChangeLog"

need_apache2
