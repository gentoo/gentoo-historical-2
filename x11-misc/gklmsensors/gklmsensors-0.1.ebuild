# Copyright 2002 Robin Cull
# Distributed under the terms of the GNU General Public License v2
# Author: Robin Cull <robin@digitalevacuation.org>
# $Header: /var/cvsroot/gentoo-x86/x11-misc/gklmsensors/gklmsensors-0.1.ebuild,v 1.1 2002/05/21 08:21:00 blocke Exp $

S=${WORKDIR}/gklmsensors
DESCRIPTION="A GKrellm plugin for monitoring lm_sensors"
HOMEPAGE="http://sourceforge.net/projects/gklmsensors"

SRC_URI1="http://telia.dl.sourceforge.net/sourceforge/gklmsensors/${P}.tar.bz2"
SRC_URI2="http://unc.dl.sourceforge.net/sourceforge/gklmsensors/${P}.tar.bz2"
SRC_URI3="http://belnet.dl.sourceforge.net/sourceforge/gklmsensors/${P}.tar.bz2"
SRC_URI="${SRC_URI1} ${SRC_URI2} ${SRC_URI3}"

LICENSE="GPL"
SLOT="0"

DEPEND=">=app-admin/gkrellm-1.0.6
		>=sys-apps/lm_sensors-2.6.3"

src_compile() {
	emake all || die
}

src_install() {
	insinto /usr/lib/gkrellm/plugins
	doins sensors.so	
}

