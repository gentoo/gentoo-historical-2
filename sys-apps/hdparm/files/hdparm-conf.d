# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hdparm/files/hdparm-conf.d,v 1.2 2004/03/06 04:09:07 vapier Exp $

# You can either set hdparm arguments for each drive using disc*_args and cdrom*_args..
# eg.
# disc0_args="-d1 -X66"
# disc1_args"-d1"
# cdrom0_args="-d1"

# Or, you can set hdparm options for ALL drives using all_args..
# eg.
# this mimics the behavior of the current script
all_args="-d1"
